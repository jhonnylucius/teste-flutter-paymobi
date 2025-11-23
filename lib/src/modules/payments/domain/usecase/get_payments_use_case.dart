import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:dartz/dartz.dart';

class GetPaymentsUseCase implements UseCase<PaymentsInfoEntity, NoParams> {
  final PaymentsRepository _repository;

  GetPaymentsUseCase(this._repository);

  @override
  Future<Either<Failure, PaymentsInfoEntity>> call([NoParams? params]) async {
    final result = await _repository.getPayments();

    if (result.isRight()) {
      final paymentsInfo = result.asRight();

      paymentsInfo.paymentsScheduled
        ..removeWhere((payment) => payment.paymentDate.isBefore(DateTime.now()))
        ..sort((a, b) => a.paymentDate.compareTo(b.paymentDate));

      // Recalcula summary baseado nas transactions reais
      final recalculatedSummary = _calculateRealSummary(
        paymentsInfo.transactions,
      );

      // Retorna novo PaymentsInfoEntity com summary correto
      return Right(
        PaymentsInfoModel.fromCalculated(
          paymentsScheduled: paymentsInfo.paymentsScheduled,
          summary: recalculatedSummary,
          transactionFilter: paymentsInfo.transactionFilter,
          transactions: paymentsInfo.transactions,
        ),
      );
    } else {
      return result;
    }
  }

  /// Calcula valores reais do summary baseado nas transactions
  List<PaymentsSummaryEntity> _calculateRealSummary(
    List<PaymentsTransactionsEntity> transactions,
  ) {
    // Total Paid: soma de todos os pagamentos
    final totalPaid = transactions.fold<double>(
      0.0,
      (sum, t) => sum + t.actualPaymentAmount,
    );

    // Principal Paid: soma de principal de todos os pagamentos
    final principalPaid = transactions.fold<double>(
      0.0,
      (sum, t) => sum + t.actualPrincipalPaymentAmount,
    );

    // Interest Paid: soma de juros de todos os pagamentos
    final interestPaid = transactions.fold<double>(
      0.0,
      (sum, t) => sum + t.actualInterestPaymentAmount,
    );

    // Outstanding Balance: pega o saldo mais recente (primeira transação, pois está ordenada desc)
    final outstandingBalance =
        transactions.isNotEmpty
            ? transactions.first.outstandingLoanBalance
            : 0.0;

    return [
      PaymentsSummaryModel(
        label: 'Outstanding Balance',
        value: outstandingBalance,
      ),
      PaymentsSummaryModel(label: 'Total Paid', value: totalPaid),
      PaymentsSummaryModel(label: 'Principal Paid', value: principalPaid),
      PaymentsSummaryModel(label: 'Interest Paid', value: interestPaid),
    ];
  }
}
