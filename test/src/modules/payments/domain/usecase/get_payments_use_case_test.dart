import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentsRepository extends Mock implements PaymentsRepository {}

void main() {
  late GetPaymentsUseCase useCase;
  late MockPaymentsRepository mockRepository;

  setUp(() {
    mockRepository = MockPaymentsRepository();
    useCase = GetPaymentsUseCase(mockRepository);
  });

  group('GetPaymentsUseCase', () {
    final now = DateTime.now();
    final futureDate1 = now.add(const Duration(days: 10));
    final futureDate2 = now.add(const Duration(days: 20));
    final futureDate3 = now.add(const Duration(days: 5));
    final pastDate = now.subtract(const Duration(days: 5));

    final tPaymentsInfo = PaymentsInfoModel.fromJson({
      'paymentsScheduled': [
        {
          'paymentDate': futureDate2.toIso8601String(),
          'principal': 10.75,
          'interest': 29.25,
          'total': 40.0,
          'outstandingBalance': 1989.25,
          'pastDue': false,
          'status': 'scheduled',
          'paymentType': 'ACH',
        },
        {
          'paymentDate': futureDate1.toIso8601String(),
          'principal': 15.00,
          'interest': 25.00,
          'total': 40.0,
          'outstandingBalance': 1974.25,
          'pastDue': false,
          'status': 'scheduled',
          'paymentType': 'ACH',
        },
        {
          'paymentDate': futureDate3.toIso8601String(),
          'principal': 5.00,
          'interest': 35.00,
          'total': 40.0,
          'outstandingBalance': 1995.00,
          'pastDue': false,
          'status': 'scheduled',
          'paymentType': 'ACH',
        },
        {
          'paymentDate': pastDate.toIso8601String(),
          'principal': 10.00,
          'interest': 30.00,
          'total': 40.0,
          'outstandingBalance': 2000.00,
          'pastDue': true,
          'status': 'past_due',
          'paymentType': 'ACH',
        },
      ],
      'summary': [
        {'label': 'Outstanding Balance', 'value': 8888.88},
      ],
      'transactionFilter': [
        {'key': 'processDate', 'label': 'Process Date', 'isDefault': true},
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

    test('should get payments from repository successfully', () async {
      // Arrange
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Right(tPaymentsInfo));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<Failure, PaymentsInfoEntity>>());
      verify(() => mockRepository.getPayments()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should remove past payments from paymentsScheduled', () async {
      // Arrange
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Right(tPaymentsInfo));

      // Act
      final result = await useCase();

      // Assert
      result.fold((_) => fail('Should return success'), (paymentsInfo) {
        // Should have 3 future payments, past payment removed
        expect(paymentsInfo.paymentsScheduled.length, 3);
        // Verify all remaining payments are in the future
        for (final payment in paymentsInfo.paymentsScheduled) {
          expect(
            payment.paymentDate.isAfter(now) ||
                payment.paymentDate.isAtSameMomentAs(now),
            true,
          );
        }
      });
    });

    test('should sort paymentsScheduled by date ascending', () async {
      // Arrange
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Right(tPaymentsInfo));

      // Act
      final result = await useCase();

      // Assert
      result.fold((_) => fail('Should return success'), (paymentsInfo) {
        final payments = paymentsInfo.paymentsScheduled;
        expect(payments.length, 3);
        // Verify sorted order: futureDate3 (5 days), futureDate1 (10 days), futureDate2 (20 days)
        expect(payments[0].paymentDate.isBefore(payments[1].paymentDate), true);
        expect(payments[1].paymentDate.isBefore(payments[2].paymentDate), true);
      });
    });

    test('should return failure when repository returns failure', () async {
      // Arrange
      final tFailure = GenericFailure(message: 'Repository error');
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Left<Failure, PaymentsInfoEntity>>());
      result.fold((failure) {
        expect(failure, tFailure);
        expect(failure.message, 'Repository error');
      }, (_) => fail('Should return failure'));
      verify(() => mockRepository.getPayments()).called(1);
    });

    test(
      'should preserve other data fields (summary, transactions, filters)',
      () async {
        // Arrange
        when(
          () => mockRepository.getPayments(),
        ).thenAnswer((_) async => Right(tPaymentsInfo));

        // Act
        final result = await useCase();

        // Assert
        result.fold((_) => fail('Should return success'), (paymentsInfo) {
          expect(
            paymentsInfo.summary.length,
            4,
          ); // Outstanding Balance, Total Paid, Principal Paid, Interest Paid
          expect(paymentsInfo.transactionFilter.length, 1);
          expect(paymentsInfo.transactions.length, 1);
        });
      },
    );

    test('should work with NoParams', () async {
      // Arrange
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Right(tPaymentsInfo));

      // Act
      final result = await useCase(NoParams());

      // Assert
      expect(result, isA<Right<Failure, PaymentsInfoEntity>>());
      verify(() => mockRepository.getPayments()).called(1);
    });

    test('should handle empty paymentsScheduled list', () async {
      // Arrange
      final emptyPaymentsInfo = PaymentsInfoModel.fromJson({
        'paymentsScheduled': [],
        'summary': [],
        'transactionFilter': [],
        'transactions': [],
      });
      when(
        () => mockRepository.getPayments(),
      ).thenAnswer((_) async => Right(emptyPaymentsInfo));

      // Act
      final result = await useCase();

      // Assert
      result.fold((_) => fail('Should return success'), (paymentsInfo) {
        expect(paymentsInfo.paymentsScheduled, isEmpty);
      });
    });
  });
}
