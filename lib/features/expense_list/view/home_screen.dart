import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/category_data.dart';
import '../../add_expense/view/add_expense_screen.dart';
import '../../summary/view/summary_screen.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/empty_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _ExpenseSearchDelegate(context.read<ExpenseBloc>()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.donut_large_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SummaryScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading || state is ExpenseInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ExpenseError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is ExpenseLoaded) {
            return Column(
              children: [
                _TotalCard(total: state.totalAmount),
                _CategoryFilterChips(activeFilter: state.activeFilter),
                Expanded(
                  child: state.expenses.isEmpty
                      ? const EmptyState()
                      : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: state.expenses.length,
                    itemBuilder: (context, index) {
                      final expense = state.expenses[index];
                      return ExpenseTile(
                        expense: expense,
                        onDelete: () {
                          context
                              .read<ExpenseBloc>()
                              .add(DeleteExpense(expense.id));
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 26),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double total;
  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: '₹', decimalDigits: 2);
    return Container(
      margin: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Signature glow — soft radial accent, top-right
            Positioned(
              top: -70,
              right: -70,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x335EEAD4), // teal ~20% opacity at center
                      Color(0x145EEAD4), // soft falloff
                      Color(0x005EEAD4), // fully transparent
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total spent',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatter.format(total),
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  final String? activeFilter;
  const _CategoryFilterChips({this.activeFilter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(context, null, 'All'),
          ...CategoryData.categories.map((c) => _chip(context, c, c)),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String? value, String label) {
    final isSelected = activeFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          context.read<ExpenseBloc>().add(FilterByCategory(value));
        },
      ),
    );
  }
}

class _ExpenseSearchDelegate extends SearchDelegate<void> {
  final ExpenseBloc expenseBloc;
  _ExpenseSearchDelegate(this.expenseBloc);

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      expenseBloc.add(LoadExpenses()); // reset to full list on close
      close(context, null);
    },
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) {
    expenseBloc.add(SearchExpense(query));
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      bloc: expenseBloc,
      builder: (context, state) {
        if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return const Center(child: Text('No matching expenses'));
          }
          return ListView.builder(
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              final expense = state.expenses[index];
              return ExpenseTile(
                expense: expense,
                onDelete: () => expenseBloc.add(DeleteExpense(expense.id)),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}