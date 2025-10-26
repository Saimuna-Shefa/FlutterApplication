import 'package:flutter/material.dart';

class MoneyCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MoneyCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1), // If you see a deprecation warning, keep it; it still works.
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}