import 'package:base_project/src/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConverterHelper', () {
    group('dynamicToDouble', () {
      test('should convert double to double', () {
        // Arrange
        const value = 10.5;

        // Act
        final result = ConverterHelper.dynamicToDouble(value);

        // Assert
        expect(result, 10.5);
        expect(result, isA<double>());
      });

      test('should convert int to double', () {
        // Arrange
        const value = 10;

        // Act
        final result = ConverterHelper.dynamicToDouble(value);

        // Assert
        expect(result, 10.0);
        expect(result, isA<double>());
      });

      test('should throw exception for invalid type', () {
        // Arrange
        const value = '10.5';

        // Act & Assert
        expect(
          () => ConverterHelper.dynamicToDouble(value),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle zero values', () {
        // Arrange
        const value = 0;

        // Act
        final result = ConverterHelper.dynamicToDouble(value);

        // Assert
        expect(result, 0.0);
      });

      test('should handle negative values', () {
        // Arrange
        const value = -25.5;

        // Act
        final result = ConverterHelper.dynamicToDouble(value);

        // Assert
        expect(result, -25.5);
      });
    });

    group('stringNullableToMMDDYYYY', () {
      test('should format valid date string', () {
        // Arrange
        const dateString = '2024-07-03T00:00:00';

        // Act
        final result = ConverterHelper.stringNullableToMMDDYYYY(dateString);

        // Assert
        expect(result, '07/03/2024');
      });

      test('should return empty string for null', () {
        // Act
        final result = ConverterHelper.stringNullableToMMDDYYYY(null);

        // Assert
        expect(result, '');
      });

      test('should return empty string for empty string', () {
        // Act
        final result = ConverterHelper.stringNullableToMMDDYYYY('');

        // Assert
        expect(result, '');
      });

      test('should format date with different month', () {
        // Arrange
        const dateString = '2024-12-25T23:59:59';

        // Act
        final result = ConverterHelper.stringNullableToMMDDYYYY(dateString);

        // Assert
        expect(result, '12/25/2024');
      });

      test('should format date with single digit day', () {
        // Arrange
        const dateString = '2024-01-05T00:00:00';

        // Act
        final result = ConverterHelper.stringNullableToMMDDYYYY(dateString);

        // Assert
        expect(result, '01/05/2024');
      });
    });

    group('currencyFormatter', () {
      test('should format positive currency value', () {
        // Arrange
        const value = 1234.56;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '\$1234.56');
      });

      test('should return replacement symbol for zero value', () {
        // Arrange
        const value = 0.0;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '--');
      });

      test('should use custom replacement symbol for zero', () {
        // Arrange
        const value = 0.0;
        const customSymbol = 'N/A';

        // Act
        final result = ConverterHelper.currencyFormatter(value, customSymbol);

        // Assert
        expect(result, 'N/A');
      });

      test('should format whole numbers without decimals', () {
        // Arrange
        const value = 100.0;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '\$100');
      });

      test('should format decimal numbers with two decimal places', () {
        // Arrange
        const value = 99.99;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '\$99.99');
      });

      test('should format large currency values', () {
        // Arrange
        const value = 8888.88;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '\$8888.88');
      });

      test('should format small decimal values', () {
        // Arrange
        const value = 0.01;

        // Act
        final result = ConverterHelper.currencyFormatter(value);

        // Assert
        expect(result, '\$0.01');
      });
    });
  });
}
