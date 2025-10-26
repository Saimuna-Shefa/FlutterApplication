import 'package:flutter/material.dart';
import '../models.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem item;
  final VoidCallback onDelete;

  const TransactionTile({super.key, required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = item.type == 'income' ? Colors.green : Colors.red;
    return Dismissible(
      key: Key(item.id ?? ''),
      background: Container(color: Colors.redAccent),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(item.type == 'income' ? Icons.call_received : Icons.call_made, color: color),
        ),
        title: Text(item.note.isEmpty ? item.category : item.note),
        subtitle: Text('${item.category} · ${item.type}${item.mood != null ? ' · ${item.mood}' : ''}'),
        trailing: Text(
          '${item.type == 'income' ? '+' : '-'}${item.amount.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}