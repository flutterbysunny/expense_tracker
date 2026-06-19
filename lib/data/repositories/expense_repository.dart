import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseRepository {
  static const String boxName = 'expenses';

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(boxName);

  // CREATE
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  // READ - all
  List<ExpenseModel> getAllExpenses() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  // READ - by category
  List<ExpenseModel> getExpensesByCategory(String category) {
    return getAllExpenses().where((e) => e.category == category).toList();
  }

  // UPDATE
  Future<void> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  // DELETE
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  // Total amount
  double getTotalAmount() {
    return getAllExpenses().fold(0.0, (sum, e) => sum + e.amount);
  }

  // Category-wise totals (for pie chart later)
  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var expense in getAllExpenses()) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}