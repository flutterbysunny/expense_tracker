import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:expense_tracker/data/models/expense_model.dart';
import 'package:expense_tracker/data/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense_list/bloc/expense_bloc.dart';
import 'package:expense_tracker/features/expense_list/bloc/expense_event.dart';
import 'package:expense_tracker/features/expense_list/bloc/expense_state.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

class FakeExpenseModel extends Fake implements ExpenseModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeExpenseModel());
  });

  late MockExpenseRepository mockRepository;

  final expense1 = ExpenseModel(
    id: '1',
    title: 'Coffee',
    amount: 150.0,
    category: 'Food',
    date: DateTime(2026, 6, 1),
  );

  final expense2 = ExpenseModel(
    id: '2',
    title: 'Bus Ticket',
    amount: 50.0,
    category: 'Transport',
    date: DateTime(2026, 6, 2),
  );

  setUp(() {
    mockRepository = MockExpenseRepository();
  });

  group('ExpenseBloc', () {
    test('initial state is ExpenseInitial', () {
      final bloc = ExpenseBloc(mockRepository);
      expect(bloc.state, isA<ExpenseInitial>());
    });

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseLoaded] when LoadExpenses succeeds',
      build: () {
        when(() => mockRepository.getAllExpenses())
            .thenReturn([expense1, expense2]);
        when(() => mockRepository.getTotalAmount()).thenReturn(200.0);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoadExpenses()),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.length, 'expenses length', 2)
            .having((s) => s.totalAmount, 'totalAmount', 200.0),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits [ExpenseLoading, ExpenseError] when LoadExpenses throws',
      build: () {
        when(() => mockRepository.getAllExpenses())
            .thenThrow(Exception('DB read failed'));
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(LoadExpenses()),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseError>(),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'calls repository.addExpense and reloads expenses on AddExpense',
      build: () {
        when(() => mockRepository.addExpense(any())).thenAnswer((_) async {});
        when(() => mockRepository.getAllExpenses()).thenReturn([expense1]);
        when(() => mockRepository.getTotalAmount()).thenReturn(150.0);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(AddExpense(expense1)),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.length, 'expenses length', 1),
      ],
      verify: (_) {
        verify(() => mockRepository.addExpense(expense1)).called(1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'calls repository.deleteExpense and reloads expenses on DeleteExpense',
      build: () {
        when(() => mockRepository.deleteExpense(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllExpenses()).thenReturn([expense2]);
        when(() => mockRepository.getTotalAmount()).thenReturn(50.0);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const DeleteExpense('1')),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.first.id, 'remaining id', '2'),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteExpense('1')).called(1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'calls repository.updateExpense and reloads expenses on UpdateExpense',
      build: () {
        final updated = expense1.copyWith(title: 'Iced Coffee', amount: 180.0);
        when(() => mockRepository.updateExpense(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllExpenses()).thenReturn([updated]);
        when(() => mockRepository.getTotalAmount()).thenReturn(180.0);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(UpdateExpense(expense1.copyWith(
        title: 'Iced Coffee',
        amount: 180.0,
      ))),
      expect: () => [
        isA<ExpenseLoading>(),
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.first.title, 'title', 'Iced Coffee'),
      ],
      verify: (_) {
        verify(() => mockRepository.updateExpense(any())).called(1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits filtered expenses when FilterByCategory is added',
      build: () {
        when(() => mockRepository.getExpensesByCategory('Food'))
            .thenReturn([expense1]);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const FilterByCategory('Food')),
      expect: () => [
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.length, 'filtered length', 1)
            .having((s) => s.activeFilter, 'activeFilter', 'Food'),
      ],
      verify: (_) {
        verify(() => mockRepository.getExpensesByCategory('Food')).called(1);
      },
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'emits all expenses when FilterByCategory(null) is added (show all)',
      build: () {
        when(() => mockRepository.getAllExpenses())
            .thenReturn([expense1, expense2]);
        return ExpenseBloc(mockRepository);
      },
      act: (bloc) => bloc.add(const FilterByCategory(null)),
      expect: () => [
        isA<ExpenseLoaded>()
            .having((s) => s.expenses.length, 'all expenses length', 2)
            .having((s) => s.activeFilter, 'activeFilter', null),
      ],
    );
  });
}