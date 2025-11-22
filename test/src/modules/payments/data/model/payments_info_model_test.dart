import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsInfoModel', () {
    test('should create model from complete JSON', () {
      // Arrange
      final json = {
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
          {'label': 'Total Paid', 'value': 777.0},
        ],
        'transactionFilter': [
          {'key': 'processDate', 'label': 'Process Date', 'isDefault': true},
          {'key': 'actualPaymentAmount', 'label': 'Amount', 'isDefault': true},
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
      };

      // Act
      final result = PaymentsInfoModel.fromJson(json);

      // Assert
      expect(result.paymentsScheduled.length, 1);
      expect(result.summary.length, 2);
      expect(result.transactionFilter.length, 2);
      expect(result.transactions.length, 1);
    });

    test('should create empty model from empty JSON', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = PaymentsInfoModel.fromJson(json);

      // Assert
      expect(result.paymentsScheduled, isEmpty);
      expect(result.summary, isEmpty);
      expect(result.transactionFilter, isEmpty);
      expect(result.transactions, isEmpty);
    });

    test('should sort paymentsScheduled by date', () {
      // Arrange
      final json = {
        'paymentsScheduled': [
          {
            'paymentDate': '2024-12-25T00:00:00',
            'principal': 0,
            'interest': 40,
            'total': 40,
            'outstandingBalance': 0,
            'pastDue': false,
            'status': 'scheduled',
            'paymentType': 'ACH',
          },
          {
            'paymentDate': '2024-07-03T00:00:00',
            'principal': 0,
            'interest': 40,
            'total': 40,
            'outstandingBalance': 0,
            'pastDue': false,
            'status': 'scheduled',
            'paymentType': 'ACH',
          },
          {
            'paymentDate': '2024-09-15T00:00:00',
            'principal': 0,
            'interest': 40,
            'total': 40,
            'outstandingBalance': 0,
            'pastDue': false,
            'status': 'scheduled',
            'paymentType': 'ACH',
          },
        ],
        'summary': [],
        'transactionFilter': [],
        'transactions': [],
      };

      // Act
      final result = PaymentsInfoModel.fromJson(json);

      // Assert
      expect(result.paymentsScheduled.length, 3);
      expect(
        result.paymentsScheduled[0].paymentDate,
        DateTime.parse('2024-07-03T00:00:00'),
      );
      expect(
        result.paymentsScheduled[1].paymentDate,
        DateTime.parse('2024-09-15T00:00:00'),
      );
      expect(
        result.paymentsScheduled[2].paymentDate,
        DateTime.parse('2024-12-25T00:00:00'),
      );
    });

    test('should sort transactions by processDate descending', () {
      // Arrange
      final json = {
        'paymentsScheduled': [],
        'summary': [],
        'transactionFilter': [],
        'transactions': [
          {
            'paymentId': 1,
            'actualPaymentPostDate': '2024-06-20T00:00:00',
            'processDate': '2024-06-20T02:24:00',
            'actualPaymentAmount': 40,
            'actualPrincipalPaymentAmount': 0,
            'actualInterestPaymentAmount': 40,
            'outstandingPrincipalBalance': 2000,
            'outstandingLoanBalance': 2040,
            'actualFee': 0,
            'paymentType': 'ACH',
          },
          {
            'paymentId': 3,
            'actualPaymentPostDate': '2024-08-15T00:00:00',
            'processDate': '2024-08-15T12:47:22',
            'actualPaymentAmount': 40,
            'actualPrincipalPaymentAmount': 10.75,
            'actualInterestPaymentAmount': 29.25,
            'outstandingPrincipalBalance': 1989.25,
            'outstandingLoanBalance': 2029.25,
            'actualFee': 0,
            'paymentType': 'ACH',
          },
          {
            'paymentId': 2,
            'actualPaymentPostDate': '2024-07-03T00:00:00',
            'processDate': '2024-07-04T05:23:51',
            'actualPaymentAmount': 40,
            'actualPrincipalPaymentAmount': 0,
            'actualInterestPaymentAmount': 40,
            'outstandingPrincipalBalance': 2000,
            'outstandingLoanBalance': 2040,
            'actualFee': 0,
            'paymentType': 'ACH',
          },
        ],
      };

      // Act
      final result = PaymentsInfoModel.fromJson(json);

      // Assert
      expect(result.transactions.length, 3);
      // Most recent first
      expect(result.transactions[0].key, '3');
      expect(result.transactions[1].key, '2');
      expect(result.transactions[2].key, '1');
    });

    test('should create empty model using empty constructor', () {
      // Act
      final result = PaymentsInfoModel.empty();

      // Assert
      expect(result.paymentsScheduled, isEmpty);
      expect(result.summary, isEmpty);
      expect(result.transactionFilter, isEmpty);
      expect(result.transactions, isEmpty);
    });

    test('should handle null values in JSON', () {
      // Arrange
      final json = {
        'paymentsScheduled': null,
        'summary': null,
        'transactionFilter': null,
        'transactions': null,
      };

      // Act
      final result = PaymentsInfoModel.fromJson(json);

      // Assert
      expect(result.paymentsScheduled, isEmpty);
      expect(result.summary, isEmpty);
      expect(result.transactionFilter, isEmpty);
      expect(result.transactions, isEmpty);
    });
  });
}
