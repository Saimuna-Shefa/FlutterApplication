import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class Db {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) {
      throw StateError('User not signed in');
    }
    return u.uid;
  }

  CollectionReference<Map<String, dynamic>> get _txns =>
      _db.collection('users').doc(_uid).collection('transactions');

  CollectionReference<Map<String, dynamic>> get _goals =>
      _db.collection('users').doc(_uid).collection('goals');

  // Transactions
  Future<List<TransactionItem>> getTransactions() async {
    final snap = await _txns.orderBy('date', descending: true).get();
    return snap.docs.map((d) => TransactionItem.fromMap(d.id, d.data())).toList();
  }

  Future<void> addTransaction(TransactionItem t) => _txns.add(t.toMap());

  Future<void> deleteTransaction(String id) => _txns.doc(id).delete();

  // Goals
  Future<List<Goal>> getGoals() async {
    final snap = await _goals.orderBy('title').get();
    return snap.docs.map((d) => Goal.fromMap(d.id, d.data())).toList(); // typed List<Goal>
  }

  Future<void> addGoal(Goal g) => _goals.add(g.toMap());

  Future<void> updateGoal(Goal g) {
    if (g.id == null) throw ArgumentError('Goal.id is null for update');
    return _goals.doc(g.id!).update(g.toMap());
  }

  Future<void> deleteGoal(String id) => _goals.doc(id).delete();
}