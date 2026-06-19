import 'package:equatable/equatable.dart';
import '../../../data/models/expense_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final ExpenseModel expense;
  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final ExpenseModel expense;
  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;
  const DeleteExpense(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterByCategory extends ExpenseEvent {
  final String? category; // null = show all
  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchExpense extends ExpenseEvent {
  final String query;
  const SearchExpense(this.query);

  @override
  List<Object?> get props => [query];
}