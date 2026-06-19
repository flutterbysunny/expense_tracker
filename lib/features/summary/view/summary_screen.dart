import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/category_data.dart';
import '../../../data/repositories/expense_repository.dart';
import '../bloc/summary_bloc.dart';
import '../bloc/summary_event.dart';
import '../bloc/summary_state.dart';
import '../widgets/category_pie_chart.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SummaryBloc(ExpenseRepository())..add(LoadSummary()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Summary')),
        body: BlocBuilder<SummaryBloc, SummaryState>(
          builder: (context, state) {
            if (state is SummaryLoading || state is SummaryInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SummaryError) {
              return Center(child: Text('Error: ${state.message}'));
            }

            if (state is SummaryLoaded) {
              if (state.categoryTotals.isEmpty) {
                return const Center(child: Text('No data to show yet'));
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CategoryPieChart(
                    categoryTotals: state.categoryTotals,
                    totalAmount: state.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Breakdown',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._buildCategoryList(state),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList(SummaryLoaded state) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    final sortedEntries = state.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.map((entry) {
      final percentage =
      state.totalAmount == 0 ? 0.0 : (entry.value / state.totalAmount) * 100;
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: CategoryData.getColor(entry.key).withOpacity(0.15),
            child: Icon(
              CategoryData.getIcon(entry.key),
              color: CategoryData.getColor(entry.key),
            ),
          ),
          title: Text(entry.key),
          subtitle: Text('${percentage.toStringAsFixed(1)}% of total'),
          trailing: Text(
            formatter.format(entry.value),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList();
  }
}