import 'package:hive/hive.dart';
import '../models/expense_model.dart';

abstract class IExpenseRepository {
  Future<void> addExpense(ExpenseModel expense);
  List<ExpenseModel> getAllExpenses();
  List<ExpenseModel> getExpensesByCategory(String category);
  Future<void> updateExpense(ExpenseModel expense);
  Future<void> deleteExpense(String id);
  double getTotalAmount();
  double getTotalIncome();
  double getTotalExpense();
  double getNetBalance();
  Map<String, double> getCategoryTotals();
  Map<DateTime, double> getLast7DaysTotals();
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
  double getTotalIncome() {
    return getAllExpenses()
        .where((e) => e.type == TransactionType.income)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  double getTotalExpense() {
    return getAllExpenses()
        .where((e) => e.type == TransactionType.expense)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  double getNetBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  @override
  Map<String, double> getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var expense in getAllExpenses()) {
      if (expense.type != TransactionType.expense) continue; // pie chart = expenses only
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  @override
  Map<DateTime, double> getLast7DaysTotals() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final days = List.generate(
      7,
          (i) => today.subtract(Duration(days: 6 - i)),
    );

    final Map<DateTime, double> totals = {for (var d in days) d: 0.0};

    for (var expense in getAllExpenses()) {
      if (expense.type != TransactionType.expense) continue; // trend = spending only
      final expenseDay = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (totals.containsKey(expenseDay)) {
        totals[expenseDay] = totals[expenseDay]! + expense.amount;
      }
    }

    return totals;
  }
}