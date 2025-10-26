import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _txns =>
      _db.collection('users').doc(_uid).collection('transactions');

  CollectionReference<Map<String, dynamic>> get _goals =>
      _db.collection('users').doc(_uid).collection('goals');

  Stream<List<TransactionItem>> transactionsStream({DateTime? from, DateTime? to}) {
    Query<Map<String, dynamic>> q = _txns.orderBy('date', descending: true);
    if (from != null) q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from));
    if (to != null) q = q.where('date', isLessThan: Timestamp.fromDate(to));
    return q.snapshots().map(
      (s) => s.docs.map((d) => TransactionItem.fromMap(d.id, d.data())).toList(),
    );
  }

  Future<void> addTransaction(TransactionItem t) => _txns.add(t.toMap());
  Future<void> deleteTransaction(String id) => _txns.doc(id).delete();

  Stream<List<Goal>> goalsStream() {
    return _goals.orderBy('title').snapshots().map(
          (s) => s.docs.map((d) => Goal.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> addGoal(Goal g) => _goals.add(g.toMap());
  Future<void> updateGoal(Goal g) => _goals.doc(g.id!).update(g.toMap());
}