import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state.dart'; // AppState or BudgetState
import '../widgets/money_card.dart';
import '../widgets/transaction_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final st = context.watch<AppState>(); // or BudgetState if that's your class

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        MoneyCard(
          title: 'Income',
          value: st.totalIncome.toStringAsFixed(2),
          icon: Icons.trending_up,
          color: Colors.green,
        ),
        MoneyCard(
          title: 'Expense',
          value: st.totalExpense.toStringAsFixed(2),
          icon: Icons.trending_down,
          color: Colors.red,
        ),
        MoneyCard(
          title: 'Balance',
          value: st.balance.toStringAsFixed(2),
          icon: Icons.account_balance_wallet,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
        Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        if (st.transactions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: Text('No transactions yet')),
          )
        else
          for (final t in st.transactions)
            TransactionTile(
              item: t,
              onDelete: () => context.read<AppState>().deleteTransaction(t.id!), // adjust for your state
            ),
      ],
    );
  }
}