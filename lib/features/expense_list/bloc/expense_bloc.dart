import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;

  ExpenseBloc(this.repository) : super(ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<FilterByCategory>(_onFilterByCategory);
  }

  void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    try {
      final expenses = repository.getAllExpenses();
      emit(ExpenseLoaded(
        expenses: expenses,
        totalAmount: repository.getTotalAmount(),
      ));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    try {
      await repository.addExpense(event.expense);
      add(LoadExpenses()); // reload after add
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onUpdateExpense(UpdateExpense event, Emitter<ExpenseState> emit) async {
    try {
      await repository.updateExpense(event.expense);
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onDeleteExpense(DeleteExpense event, Emitter<ExpenseState> emit) async {
    try {
      await repository.deleteExpense(event.id);
      add(LoadExpenses());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  void _onFilterByCategory(FilterByCategory event, Emitter<ExpenseState> emit) {
    try {
      final expenses = event.category == null
          ? repository.getAllExpenses()
          : repository.getExpensesByCategory(event.category!);
      final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
      emit(ExpenseLoaded(
        expenses: expenses,
        totalAmount: total,
        activeFilter: event.category,
      ));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}