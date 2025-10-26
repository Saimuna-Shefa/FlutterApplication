import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionItem {
  final String? id;
  final double amount;
  final String note;
  final DateTime date;
  final String type; // 'income' | 'expense'
  final String category;
  final String? mood;

  TransactionItem({
    this.id,
    required this.amount,
    required this.note,
    required this.date,
    required this.type,
    required this.category,
    this.mood,
  });

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'note': note,
        'date': Timestamp.fromDate(date),
        'type': type,
        'category': category,
        'mood': mood,
      };

  factory TransactionItem.fromMap(String id, Map<String, dynamic> map) => TransactionItem(
        id: id,
        amount: (map['amount'] as num).toDouble(),
        note: map['note'] ?? '',
        date: (map['date'] as Timestamp).toDate(),
        type: map['type'] ?? 'expense',
        category: map['category'] ?? 'General',
        mood: map['mood'],
      );
}

class Goal {
  final String? id;
  final String title;
  final double targetAmount;
  final double savedAmount;

  Goal({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'targetAmount': targetAmount,
        'savedAmount': savedAmount,
      };

  factory Goal.fromMap(String id, Map<String, dynamic> map) => Goal(
        id: id,
        title: map['title'] ?? '',
        targetAmount: (map['targetAmount'] as num).toDouble(),
        savedAmount: (map['savedAmount'] as num).toDouble(),
      );
}