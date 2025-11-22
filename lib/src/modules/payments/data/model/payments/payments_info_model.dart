import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

class PaymentsInfoModel extends PaymentsInfoEntity {
  PaymentsInfoModel.fromJson(Map<String, dynamic> json)
    : super(
        paymentsScheduled:
            json['paymentsScheduled'] != null
                ? ((json['paymentsScheduled'] as List)
                    .map((json) => PaymentsScheduledModel.fromJson(json))
                    .toList()
                  ..sort((a, b) => a.paymentDate.compareTo(b.paymentDate)))
                : [],
        transactionFilter:
            json['transactionFilter'] != null
                ? (json['transactionFilter'] as List)
                    .map(
                      (json) => PaymentsTransactionHeadersModel.fromJson(json),
                    )
                    .toList()
                : [],
        transactions:
            json['transactions'] != null
                ? ((json['transactions'] as List)
                    .map((json) => PaymentsTransactionsModel.fromJson(json))
                    .toList()
                  ..sort((a, b) => b.processDate.compareTo(a.processDate)))
                : [],
        summary:
            json['summary'] != null
                ? (json['summary'] as List)
                    .map((json) => PaymentsSummaryModel.fromJson(json))
                    .toList()
                : [],
      );
  PaymentsInfoModel.empty() : this.fromJson({});
}
