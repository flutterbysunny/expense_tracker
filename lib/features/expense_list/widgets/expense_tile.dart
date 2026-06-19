import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/category_data.dart';
import '../../../data/models/expense_model.dart';

class ExpenseTile extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback onDelete;

  const ExpenseTile({super.key, required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final dateFormatter = DateFormat('dd MMM, yyyy');

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: CategoryData.getColor(expense.category).withOpacity(0.15),
          child: Icon(
            CategoryData.getIcon(expense.category),
            color: CategoryData.getColor(expense.category),
          ),
        ),
        title: Text(expense.title),
        subtitle: Text('${expense.category} • ${dateFormatter.format(expense.date)}'),
        trailing: Text(
          formatter.format(expense.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}