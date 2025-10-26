import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models.dart';   // TransactionItem from models.dart
import 'state.dart';   // AppState/BudgetState

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _type = 'expense';
  String _category = 'General';
  String? _mood;
  DateTime _selectedDate = DateTime.now();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0.0;
    final note = _noteCtrl.text.trim();

    final tx = TransactionItem(
      amount: amount,
      note: note,
      date: _selectedDate,
      type: _type,
      category: _category,
      mood: _mood,
    );

    try {
      // Nijer state-er class onujayi call koro:
      // await context.read<BudgetState>().addTransaction(tx);
      await context.read<AppState>().addTransaction(tx);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Amount
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an amount';
                  final v = double.tryParse(value);
                  if (v == null) return 'Enter a valid number';
                  if (v <= 0) return 'Amount must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Note
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Note'),
                minLines: 1,
                maxLines: 3,
              ),
              const SizedBox(height: 12),

              // Type
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'expense'),
              ),
              const SizedBox(height: 12),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'General', child: Text('General')),
                  DropdownMenuItem(value: 'Food', child: Text('Food')),
                  DropdownMenuItem(value: 'Transport', child: Text('Transport')),
                  DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                ],
                onChanged: (v) => setState(() => _category = v ?? 'General'),
              ),
              const SizedBox(height: 12),

              // Mood (optional)
              TextFormField(
                decoration: const InputDecoration(labelText: 'Mood (optional)'),
                onChanged: (v) => _mood = v,
              ),
              const SizedBox(height: 12),

              // Date Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Date: ${_selectedDate.toLocal().toString().split(' ').first}'),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Submit
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  child: Text(_isSubmitting ? 'Saving...' : 'Add Transaction'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}