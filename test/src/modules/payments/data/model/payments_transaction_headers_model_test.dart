import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaymentsTransactionHeadersModel', () {
    test('should create model from valid JSON', () {
      // Arrange
      final json = {
        'key': 'processDate',
        'label': 'Process Date',
        'isDefault': true,
      };

      // Act
      final result = PaymentsTransactionHeadersModel.fromJson(json);

      // Assert
      expect(result.key, 'processDate');
      expect(result.label, 'Process Date');
      expect(result.isDefault, true);
    });

    test('should handle non-default filter', () {
      // Arrange
      final json = {
        'key': 'actualFee',
        'label': 'Late Fee',
        'isDefault': false,
      };

      // Act
      final result = PaymentsTransactionHeadersModel.fromJson(json);

      // Assert
      expect(result.key, 'actualFee');
      expect(result.label, 'Late Fee');
      expect(result.isDefault, false);
    });

    test('should use default values for missing fields', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final result = PaymentsTransactionHeadersModel.fromJson(json);

      // Assert
      expect(result.key, '');
      expect(result.label, '');
      expect(result.isDefault, false);
    });

    test('should handle multiple filter types', () {
      // Arrange
      final filters = [
        {'key': 'processDate', 'label': 'Process Date', 'isDefault': true},
        {'key': 'actualPaymentAmount', 'label': 'Amount', 'isDefault': true},
        {'key': 'type', 'label': 'Type', 'isDefault': true},
        {
          'key': 'actualPrincipalPaymentAmount',
          'label': 'Principal',
          'isDefault': false,
        },
      ];

      // Act
      final results =
          filters
              .map((json) => PaymentsTransactionHeadersModel.fromJson(json))
              .toList();

      // Assert
      expect(results.length, 4);
      expect(results.where((f) => f.isDefault).length, 3);
      expect(results.where((f) => !f.isDefault).length, 1);
    });
  });
}
