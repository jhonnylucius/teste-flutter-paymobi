import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsScheduledModel', () {
    test('should create model from valid JSON', () {
      // Arrange
      final json = {
        'paymentDate': '2024-07-03T00:00:00',
        'principal': 10.75,
        'interest': 29.25,
        'total': 40.0,
        'outstandingBalance': 1989.25,
        'pastDue': false,
        'status': 'scheduled',
        'paymentType': 'ACH',
      };

      // Act
      final result = PaymentsScheduledModel.fromJson(json);

      // Assert
      expect(result.paymentDate, DateTime.parse('2024-07-03T00:00:00'));
      expect(result.paymentDateFormatted, '07/03/2024');
      expect(result.principal, 10.75);
      expect(result.interest, 29.25);
      expect(result.total, 40.0);
      expect(result.outstandingBalance, 1989.25);
      expect(result.pastDue, false);
      expect(result.status, 'scheduled');
      expect(result.paymentType, 'ACH');
    });

    test('should handle integer values for double fields', () {
      // Arrange
      final json = {
        'paymentDate': '2024-07-03T00:00:00',
        'principal': 0,
        'interest': 40,
        'total': 40,
        'outstandingBalance': 0,
        'pastDue': false,
        'status': 'ok',
        'paymentType': 'ACH',
      };

      // Act
      final result = PaymentsScheduledModel.fromJson(json);

      // Assert
      expect(result.principal, 0.0);
      expect(result.interest, 40.0);
      expect(result.total, 40.0);
      expect(result.outstandingBalance, 0.0);
    });

    test('should handle pastDue status correctly', () {
      // Arrange
      final json = {
        'paymentDate': '2025-01-16T00:00:00',
        'principal': 0,
        'interest': 0,
        'total': 40,
        'outstandingBalance': 0,
        'pastDue': true,
        'status': 'past_due',
        'paymentType': 'Automatic',
      };

      // Act
      final result = PaymentsScheduledModel.fromJson(json);

      // Assert
      expect(result.pastDue, true);
      expect(result.status, 'past_due');
    });

    test('should use default values for missing fields', () {
      // Arrange
      final json = {'paymentDate': '2024-07-03T00:00:00'};

      // Act
      final result = PaymentsScheduledModel.fromJson(json);

      // Assert
      expect(result.principal, 0.0);
      expect(result.interest, 0.0);
      expect(result.total, 0.0);
      expect(result.outstandingBalance, 0.0);
      expect(result.pastDue, false);
      expect(result.status, '');
      expect(result.paymentType, '');
    });
  });
}
