import 'package:equatable/equatable.dart';

abstract class SummaryState extends Equatable {
  const SummaryState();

  @override
  List<Object?> get props => [];
}

class SummaryInitial extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummaryLoaded extends SummaryState {
  final Map<String, double> categoryTotals;
  final double totalAmount;

  const SummaryLoaded({
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [categoryTotals, totalAmount];
}

class SummaryError extends SummaryState {
  final String message;
  const SummaryError(this.message);

  @override
  List<Object?> get props => [message];
}