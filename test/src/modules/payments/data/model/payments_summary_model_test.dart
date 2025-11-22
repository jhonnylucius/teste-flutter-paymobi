import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsSummaryModel', () {
    test('should create model from valid JSON', () {
      // Arrange
      final json = {'label': 'Outstanding Balance', 'value': 8888.88};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, 'Outstanding Balance');
      expect(result.value, 8888.88);
    });

    test('should handle integer values', () {
      // Arrange
      final json = {'label': 'Total Paid', 'value': 777};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, 'Total Paid');
      expect(result.value, 777.0);
    });

    test('should handle zero values', () {
      // Arrange
      final json = {'label': 'Principal Paid', 'value': 0};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, 'Principal Paid');
      expect(result.value, 0.0);
    });

    test('should use empty string for missing label', () {
      // Arrange
      final json = {'value': 100.0};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, '');
      expect(result.value, 100.0);
    });

    test('should use 0.0 for missing value', () {
      // Arrange
      final json = {'label': 'Interest Paid'};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, 'Interest Paid');
      expect(result.value, 0.0);
    });

    test('should handle decimal values correctly', () {
      // Arrange
      final json = {'label': 'Interest Paid', 'value': 555.55};

      // Act
      final result = PaymentsSummaryModel.fromJson(json);

      // Assert
      expect(result.label, 'Interest Paid');
      expect(result.value, 555.55);
    });
  });
}
