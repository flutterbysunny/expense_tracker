import 'package:hive/hive.dart';
import '../models/expense_model.dart';

abstract class IExpenseRepository {
  Future<void> addExpense(ExpenseModel expense);
  List<ExpenseModel> getAllExpenses();
  List<ExpenseModel> getExpensesByCategory(String category);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  double getTotalAmount();
  Map<String, double> getCategoryTotals();
}

class ExpenseRepository implements IExpenseRepository {
  static const String boxName = 'expenses';

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(boxName);

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  List<ExpenseModel> getAllExpenses() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<ExpenseModel> getExpensesByCategory(String category) {
    return getAllExpenses().where((e) => e.category == category).toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _box.put(expense.id, expense);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _box.delete(id);
  }

  @override
  double getTotalAmount() {
    return getAllExpenses().fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var expense in getAllExpenses()) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }
}