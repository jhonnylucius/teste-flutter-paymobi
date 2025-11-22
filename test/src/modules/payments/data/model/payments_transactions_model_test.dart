import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsTransactionsModel', () {
    test('should create model from valid JSON', () {
      // Arrange
      final json = {
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
      };

      // Act
      final result = PaymentsTransactionsModel.fromJson(json);

      // Assert
      expect(result.key, '1');
      expect(
        result.actualPaymentPostDate,
        DateTime.parse('2024-06-20T00:00:00'),
      );
      expect(result.processDate, DateTime.parse('2024-06-20T02:24:00'));
      expect(result.actualPaymentAmount, 40.0);
      expect(result.actualPrincipalPaymentAmount, 10.75);
      expect(result.actualInterestPaymentAmount, 29.25);
      expect(result.outstandingPrincipalBalance, 2000.0);
      expect(result.outstandingLoanBalance, 2040.0);
      expect(result.actualFee, 0.0);
      expect(result.paymentType, 'ACH');
    });

    test('should handle integer values for amounts', () {
      // Arrange
      final json = {
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
      };

      // Act
      final result = PaymentsTransactionsModel.fromJson(json);

      // Assert
      expect(result.actualPaymentAmount, 40.0);
      expect(result.actualPrincipalPaymentAmount, 0.0);
      expect(result.actualInterestPaymentAmount, 40.0);
      expect(result.outstandingPrincipalBalance, 2000.0);
      expect(result.outstandingLoanBalance, 2040.0);
      expect(result.actualFee, 0.0);
    });

    test('should use default values for missing fields', () {
      // Arrange
      final json = {
        'actualPaymentPostDate': '2024-06-20T00:00:00',
        'processDate': '2024-06-20T02:24:00',
      };

      // Act
      final result = PaymentsTransactionsModel.fromJson(json);

      // Assert
      expect(result.key, '');
      expect(result.actualPaymentAmount, 0.0);
      expect(result.actualPrincipalPaymentAmount, 0.0);
      expect(result.actualInterestPaymentAmount, 0.0);
      expect(result.outstandingPrincipalBalance, 0.0);
      expect(result.outstandingLoanBalance, 0.0);
      expect(result.actualFee, 0.0);
      expect(result.paymentType, '');
    });

    test('should convert model to map correctly', () {
      // Arrange
      final json = {
        'paymentId': 1,
        'actualPaymentPostDate': '2024-06-20T00:00:00',
        'processDate': '2024-06-20T02:24:00',
        'actualPaymentAmount': 40.0,
        'actualPrincipalPaymentAmount': 10.75,
        'actualInterestPaymentAmount': 29.25,
        'outstandingPrincipalBalance': 2000.0,
        'outstandingLoanBalance': 2040.0,
        'actualFee': 5.0,
        'paymentType': 'ACH',
      };
      final model = PaymentsTransactionsModel.fromJson(json);

      // Act
      final result = model.toMap();

      // Assert
      expect(result['key'], '1');
      expect(result['actualPaymentPostDate'], '06/20/2024');
      expect(result['processDate'], '06/20/2024');
      expect(
        result['actualPaymentAmount'],
        '\$40',
      ); // Whole number without decimals
      expect(result['actualPrincipalPaymentAmount'], '\$10.75');
      expect(result['actualInterestPaymentAmount'], '\$29.25');
      expect(result['outstandingPrincipalBalance'], '\$2000');
      expect(result['outstandingLoanBalance'], '\$2040');
      expect(result['actualFee'], '\$5'); // Whole number without decimals
      expect(result['type'], 'ACH');
    });

    test('should format zero values with replacement in toMap', () {
      // Arrange
      final json = {
        'paymentId': 1,
        'actualPaymentPostDate': '2024-06-20T00:00:00',
        'processDate': '2024-06-20T02:24:00',
        'actualPaymentAmount': 0,
        'actualPrincipalPaymentAmount': 0,
        'actualInterestPaymentAmount': 0,
        'outstandingPrincipalBalance': 0,
        'outstandingLoanBalance': 0,
        'actualFee': 0,
        'paymentType': 'ACH',
      };
      final model = PaymentsTransactionsModel.fromJson(json);

      // Act
      final result = model.toMap();

      // Assert
      expect(result['actualPaymentAmount'], '--');
      expect(result['actualPrincipalPaymentAmount'], '--');
      expect(result['actualInterestPaymentAmount'], '--');
      expect(result['actualFee'], '--');
    });
  });
}
