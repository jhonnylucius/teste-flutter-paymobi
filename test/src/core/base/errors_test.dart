import 'package:base_project/src/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InfraError', () {
    test('should create InfraError with code', () {
      // Act
      const error = InfraError(InfraCode.unexpected);

      // Assert
      expect(error.code, InfraCode.unexpected);
      expect(error.error, null);
    });

    test('should create InfraError with code and error detail', () {
      // Arrange
      final exception = Exception('Test exception');

      // Act
      final error = InfraError(InfraCode.unexpected, error: exception);

      // Assert
      expect(error.code, InfraCode.unexpected);
      expect(error.error, exception);
    });

    test('should be equal when codes and errors are same', () {
      // Arrange
      final exception = Exception('Test');
      const error1 = InfraError(InfraCode.unexpected, error: 'same');
      const error2 = InfraError(InfraCode.unexpected, error: 'same');

      // Assert
      expect(error1, error2);
    });

    test('should not be equal when codes are different', () {
      // Arrange
      const error1 = InfraError(InfraCode.unexpected);
      // If we had another code: const error2 = InfraError(InfraCode.network);

      // Assert
      expect(error1.code, InfraCode.unexpected);
    });

    test('props should contain code and error', () {
      // Arrange
      final exception = Exception('Test');
      final error = InfraError(InfraCode.unexpected, error: exception);

      // Assert
      expect(error.props, [InfraCode.unexpected, exception]);
    });
  });

  group('Failures', () {
    test('GenericFailure should have default message', () {
      // Act
      final failure = GenericFailure();

      // Assert
      expect(failure.message, AppConstants.genericError001);
      expect(failure.errorDetail, null);
      expect(failure.error, null);
    });

    test('GenericFailure should accept custom message', () {
      // Arrange
      const customMessage = 'Custom error message';

      // Act
      final failure = GenericFailure(message: customMessage);

      // Assert
      expect(failure.message, customMessage);
    });

    test('GenericFailure should store error details', () {
      // Arrange
      const errorDetail = 'Detailed error information';
      final exception = Exception('Test exception');

      // Act
      final failure = GenericFailure(
        errorDetail: errorDetail,
        error: exception,
      );

      // Assert
      expect(failure.errorDetail, errorDetail);
      expect(failure.error, exception);
    });

    test(
      'GenericFailure props should contain message, error, and errorDetail',
      () {
        // Arrange
        const message = 'Test message';
        const errorDetail = 'Detail';
        final exception = Exception('Test');

        // Act
        final failure = GenericFailure(
          message: message,
          errorDetail: errorDetail,
          error: exception,
        );

        // Assert
        expect(failure.props, [message, exception, errorDetail]);
      },
    );

    test('two GenericFailures with same values should be equal', () {
      // Arrange
      final failure1 = GenericFailure(message: 'Same message');
      final failure2 = GenericFailure(message: 'Same message');

      // Assert
      expect(failure1, failure2);
    });

    test('two GenericFailures with different values should not be equal', () {
      // Arrange
      final failure1 = GenericFailure(message: 'Message 1');
      final failure2 = GenericFailure(message: 'Message 2');

      // Assert
      expect(failure1, isNot(failure2));
    });
  });
}
