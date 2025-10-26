import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../state.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>();

    final categoryTotals = <String, double>{};
    double totalExpense = 0;
    for (final t in st.transactions.where((t) => t.type == 'expense')) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
      totalExpense += t.amount;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Summary', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('Income', st.totalIncome, Colors.green),
                    _stat('Expense', st.totalExpense, Colors.red),
                    _stat('Balance', st.balance, Colors.blue),
                  ],
                ),
                const SizedBox(height: 10),
                if (st.totalExpense > st.totalIncome)
                  Text('⚠ Overspending!', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (categoryTotals.isNotEmpty)
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: categoryTotals.entries.map((e) {
                  final percent = (e.value / totalExpense * 100).toStringAsFixed(1);
                  final color = Colors.primaries[
                      categoryTotals.keys.toList().indexOf(e.key) % Colors.primaries.length];
                  return PieChartSectionData(
                    value: e.value,
                    color: color,
                    title: '$percent%',
                    radius: 80,
                    titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList(),
              ),
            ),
          )
        else
          const Center(child: Text('No expense data')),
      ],
    );
  }

  Widget _stat(String label, double value, Color color) => Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          Text(value.toStringAsFixed(2),
              style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      );
}