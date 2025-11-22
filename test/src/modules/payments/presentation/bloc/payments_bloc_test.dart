import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPaymentsUseCase extends Mock implements GetPaymentsUseCase {}

void main() {
  late PaymentsBloc bloc;
  late MockGetPaymentsUseCase mockGetPaymentsUseCase;

  setUp(() {
    mockGetPaymentsUseCase = MockGetPaymentsUseCase();
    bloc = PaymentsBloc(getPaymentsUseCase: mockGetPaymentsUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  final tPaymentsInfo = PaymentsInfoModel.fromJson({
    'paymentsScheduled': [
      {
        'paymentDate': '2025-07-03T00:00:00',
        'principal': 10.75,
        'interest': 29.25,
        'total': 40.0,
        'outstandingBalance': 1989.25,
        'pastDue': false,
        'status': 'scheduled',
        'paymentType': 'ACH',
      },
    ],
    'summary': [
      {'label': 'Outstanding Balance', 'value': 8888.88},
      {'label': 'Total Paid', 'value': 777.0},
    ],
    'transactionFilter': [
      {'key': 'processDate', 'label': 'Process Date', 'isDefault': true},
      {'key': 'actualPaymentAmount', 'label': 'Amount', 'isDefault': true},
      {'key': 'type', 'label': 'Type', 'isDefault': false},
    ],
    'transactions': [
      {
        'paymentId': 1,
        'actualPaymentPostDate': '2024-06-20T00:00:00',
        'processDate': '2024-06-20T02:24:00',
        'actualPaymentAmount': 40.0,
        'actualPrincipalPaymentAmount': 10.75,
        'actualInterestPaymentAmount': 29.25,
        'outstandingPrincipalBalance': 2000.0,
        'outstandingLoanBalance': 2040.0,
        'actualFee': 0.0,
        'paymentType': 'ACH',
      },
    ],
  });

  group('PaymentsBloc', () {
    test('initial state should be PaymentsInitialState', () {
      expect(bloc.state, const PaymentsInitialState());
    });

    blocTest<PaymentsBloc, PaymentsState>(
      'should emit [PaymentsLoadingState, PaymentsLoadedState] when LoadPaymentsEvent is successful',
      build: () {
        when(
          () => mockGetPaymentsUseCase(),
        ).thenAnswer((_) async => Right(tPaymentsInfo));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPaymentsEvent()),
      expect:
          () => [
            const PaymentsLoadingState(),
            isA<PaymentsLoadedState>()
                .having((s) => s.paymentsInfo, 'paymentsInfo', tPaymentsInfo)
                .having(
                  (s) => s.activeFilters.length,
                  'activeFilters length',
                  2,
                )
                .having(
                  (s) => s.visibleScheduleFields.isNotEmpty,
                  'visibleScheduleFields',
                  true,
                ),
          ],
      verify: (_) {
        verify(() => mockGetPaymentsUseCase()).called(1);
      },
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should emit default filters (isDefault = true) when loading payments',
      build: () {
        when(
          () => mockGetPaymentsUseCase(),
        ).thenAnswer((_) async => Right(tPaymentsInfo));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPaymentsEvent()),
      expect:
          () => [
            const PaymentsLoadingState(),
            isA<PaymentsLoadedState>().having(
              (s) => s.activeFilters,
              'activeFilters',
              containsAll(['processDate', 'actualPaymentAmount']),
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should emit [PaymentsLoadingState, PaymentsErrorState] when LoadPaymentsEvent fails',
      build: () {
        when(
          () => mockGetPaymentsUseCase(),
        ).thenAnswer((_) async => Left(GenericFailure(message: 'Test error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadPaymentsEvent()),
      expect:
          () => [
            const PaymentsLoadingState(),
            isA<PaymentsErrorState>().having(
              (s) => s.message,
              'message',
              AppConstants.genericError001,
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should emit refreshing states when RefreshPaymentsEvent is triggered',
      build: () {
        when(
          () => mockGetPaymentsUseCase(),
        ).thenAnswer((_) async => Right(tPaymentsInfo));
        return bloc;
      },
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const ['processDate'],
            visibleScheduleFields: const ['date', 'amount'],
          ),
      act: (bloc) => bloc.add(const RefreshPaymentsEvent()),
      expect:
          () => [
            isA<PaymentsRefreshingState>()
                .having((s) => s.paymentsInfo, 'paymentsInfo', tPaymentsInfo)
                .having((s) => s.activeFilters, 'activeFilters', [
                  'processDate',
                ])
                .having(
                  (s) => s.visibleScheduleFields,
                  'visibleScheduleFields',
                  ['date', 'amount'],
                ),
            isA<PaymentsLoadedState>()
                .having((s) => s.paymentsInfo, 'paymentsInfo', tPaymentsInfo)
                .having((s) => s.activeFilters, 'activeFilters', [
                  'processDate',
                ])
                .having(
                  (s) => s.visibleScheduleFields,
                  'visibleScheduleFields',
                  ['date', 'amount'],
                ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should maintain current state on refresh error',
      build: () {
        when(
          () => mockGetPaymentsUseCase(),
        ).thenAnswer((_) async => Left(GenericFailure()));
        return bloc;
      },
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const ['processDate'],
            visibleScheduleFields: const ['date'],
          ),
      act: (bloc) => bloc.add(const RefreshPaymentsEvent()),
      expect:
          () => [
            isA<PaymentsRefreshingState>(),
            isA<PaymentsLoadedState>()
                .having((s) => s.paymentsInfo, 'paymentsInfo', tPaymentsInfo)
                .having((s) => s.activeFilters, 'activeFilters', [
                  'processDate',
                ])
                .having(
                  (s) => s.visibleScheduleFields,
                  'visibleScheduleFields',
                  ['date'],
                ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should toggle transaction filter on ToggleTransactionFilterEvent',
      build: () => bloc,
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const ['processDate', 'actualPaymentAmount'],
            visibleScheduleFields: const [],
          ),
      act: (bloc) => bloc.add(const ToggleTransactionFilterEvent('type')),
      expect:
          () => [
            isA<PaymentsLoadedState>().having(
              (s) => s.activeFilters,
              'activeFilters',
              containsAll(['processDate', 'actualPaymentAmount', 'type']),
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should remove filter when toggling existing filter',
      build: () => bloc,
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const ['processDate', 'actualPaymentAmount'],
            visibleScheduleFields: const [],
          ),
      act:
          (bloc) => bloc.add(const ToggleTransactionFilterEvent('processDate')),
      expect:
          () => [
            isA<PaymentsLoadedState>().having(
              (s) => s.activeFilters,
              'activeFilters',
              ['actualPaymentAmount'],
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should toggle schedule field on ToggleScheduleFieldEvent',
      build: () => bloc,
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const [],
            visibleScheduleFields: const ['date', 'amount'],
          ),
      act: (bloc) => bloc.add(const ToggleScheduleFieldEvent('principal')),
      expect:
          () => [
            isA<PaymentsLoadedState>().having(
              (s) => s.visibleScheduleFields,
              'visibleScheduleFields',
              containsAll(['date', 'amount', 'principal']),
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should remove schedule field when toggling existing field',
      build: () => bloc,
      seed:
          () => PaymentsLoadedState(
            paymentsInfo: tPaymentsInfo,
            activeFilters: const [],
            visibleScheduleFields: const ['date', 'amount', 'principal'],
          ),
      act: (bloc) => bloc.add(const ToggleScheduleFieldEvent('amount')),
      expect:
          () => [
            isA<PaymentsLoadedState>().having(
              (s) => s.visibleScheduleFields,
              'visibleScheduleFields',
              ['date', 'principal'],
            ),
          ],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should not emit new state when toggling filters in non-loaded state',
      build: () => bloc,
      seed: () => const PaymentsLoadingState(),
      act:
          (bloc) => bloc.add(const ToggleTransactionFilterEvent('processDate')),
      expect: () => [],
    );

    blocTest<PaymentsBloc, PaymentsState>(
      'should not emit new state when toggling schedule fields in non-loaded state',
      build: () => bloc,
      seed: () => const PaymentsErrorState('Error'),
      act: (bloc) => bloc.add(const ToggleScheduleFieldEvent('date')),
      expect: () => [],
    );
  });
}
