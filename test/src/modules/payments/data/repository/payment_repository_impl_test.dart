import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPaymentsDataSource extends Mock implements PaymentsDataSource {}

void main() {
  late PaymentsRepositoryImpl repository;
  late MockPaymentsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPaymentsDataSource();
    repository = PaymentsRepositoryImpl(mockDataSource);
  });

  group('PaymentsRepositoryImpl', () {
    final tPaymentsInfo = PaymentsInfoModel.fromJson({
      'paymentsScheduled': [
        {
          'paymentDate': '2024-07-03T00:00:00',
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

    test(
      'should return PaymentsInfoEntity when datasource call is successful',
      () async {
        // Arrange
        when(
          () => mockDataSource.getPaymentsInfo(),
        ).thenAnswer((_) async => tPaymentsInfo);

        // Act
        final result = await repository.getPayments();

        // Assert
        expect(result, isA<Right<Failure, PaymentsInfoEntity>>());
        expect(result.isRight(), true);
        verify(() => mockDataSource.getPaymentsInfo()).called(1);
        verifyNoMoreInteractions(mockDataSource);
      },
    );

    test(
      'should return GenericFailure when datasource throws InfraError',
      () async {
        // Arrange
        final tInfraError = InfraError(
          InfraCode.unexpected,
          error: Exception('Datasource error'),
        );
        when(() => mockDataSource.getPaymentsInfo()).thenThrow(tInfraError);

        // Act
        final result = await repository.getPayments();

        // Assert
        expect(result, isA<Left<Failure, PaymentsInfoEntity>>());
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<GenericFailure>());
          expect(failure.error, tInfraError);
        }, (_) => fail('Should return failure'));
        verify(() => mockDataSource.getPaymentsInfo()).called(1);
      },
    );

    test(
      'should return GenericFailure when datasource throws any exception',
      () async {
        // Arrange
        final tException = Exception('Unexpected error');
        when(() => mockDataSource.getPaymentsInfo()).thenThrow(tException);

        // Act
        final result = await repository.getPayments();

        // Assert
        expect(result, isA<Left<Failure, PaymentsInfoEntity>>());
        result.fold((failure) {
          expect(failure, isA<GenericFailure>());
          expect(failure.error, tException);
        }, (_) => fail('Should return failure'));
      },
    );

    test(
      'should return PaymentsInfoEntity with all data fields populated',
      () async {
        // Arrange
        when(
          () => mockDataSource.getPaymentsInfo(),
        ).thenAnswer((_) async => tPaymentsInfo);

        // Act
        final result = await repository.getPayments();

        // Assert
        result.fold((_) => fail('Should return success'), (paymentsInfo) {
          expect(paymentsInfo.paymentsScheduled.length, 1);
          expect(paymentsInfo.summary.length, 1);
          expect(paymentsInfo.transactionFilter.length, 1);
          expect(paymentsInfo.transactions.length, 1);
        });
      },
    );
  });
}
