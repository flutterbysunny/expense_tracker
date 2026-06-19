import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/expense_repository.dart';
import 'summary_event.dart';
import 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final IExpenseRepository repository;

  SummaryBloc(this.repository) : super(SummaryInitial()) {
    on<LoadSummary>(_onLoadSummary);
  }

  void _onLoadSummary(LoadSummary event, Emitter<SummaryState> emit) {
    emit(SummaryLoading());
    try {
      final totals = repository.getCategoryTotals();
      final total = repository.getTotalAmount();
      emit(SummaryLoaded(categoryTotals: totals, totalAmount: total));
    } catch (e) {
      emit(SummaryError(e.toString()));
    }
  }
}