import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Transactions
  List<TransactionItem> _transactions = [];
  StreamSubscription? _txnSub;

  // Goals
  List<Goal> _goals = [];
  StreamSubscription? _goalSub;

  // Getters
  List<TransactionItem> get transactions => _transactions;
  List<Goal> get goals => _goals;

  double get totalIncome =>
      _transactions.where((t) => t.type == 'income').fold(0.0, (s, t) => s + t.amount);

  double get totalExpense =>
      _transactions.where((t) => t.type == 'expense').fold(0.0, (s, t) => s + t.amount);

  double get balance => totalIncome - totalExpense;

  AppState() {
    _bindAuth();
  }

  void _bindAuth() {
    _auth.authStateChanges().listen((user) {
      _cancelStreams();
      _transactions = [];
      _goals = [];
      notifyListeners();

      if (user != null) {
        final userDoc = _db.collection('users').doc(user.uid);

        _txnSub = userDoc
            .collection('transactions')
            .orderBy('date', descending: true)
            .snapshots()
            .listen((snap) {
          _transactions =
              snap.docs.map((d) => TransactionItem.fromMap(d.id, d.data())).toList();
          notifyListeners();
        });

        _goalSub = userDoc
            .collection('goals')
            .orderBy('title')
            .snapshots()
            .listen((snap) {
          _goals = snap.docs.map((d) => Goal.fromMap(d.id, d.data())).toList();
          notifyListeners();
        });
      }
    });
  }

  void _cancelStreams() {
    _txnSub?.cancel();
    _goalSub?.cancel();
    _txnSub = null;
    _goalSub = null;
  }

  // Transactions CRUD
  Future<void> addTransaction(TransactionItem t) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    await _db.collection('users').doc(user.uid).collection('transactions').add(t.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    await _db.collection('users').doc(user.uid).collection('transactions').doc(id).delete();
  }

  // Goals CRUD
  Future<void> addGoal(Goal g) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    await _db.collection('users').doc(user.uid).collection('goals').add(g.toMap());
  }

  Future<void> updateGoal(Goal g) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    if (g.id == null) throw ArgumentError('Goal.id is null for update');
    await _db
        .collection('users')
        .doc(user.uid)
        .collection('goals')
        .doc(g.id!)
        .update(g.toMap());
  }

  Future<void> deleteGoal(String id) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Not signed in');
    await _db.collection('users').doc(user.uid).collection('goals').doc(id).delete();
  }

  @override
  void dispose() {
    _cancelStreams();
    super.dispose();
  }
}