import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:intl/intl.dart';

/// Item da lista de transações
class TransactionItem extends StatelessWidget {
  final PaymentsTransactionsEntity transaction;
  final List<String> visibleFields;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.visibleFields,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_shouldShowField('processDate'))
                Expanded(
                  child: Text(
                    _formatDate(transaction.processDate),
                    style: AppTextStyles.transactionDate,
                  ),
                ),
              if (_shouldShowField('actualPaymentAmount'))
                Text(
                  _formatCurrency(transaction.actualPaymentAmount),
                  style: AppTextStyles.transactionAmount,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: [
              if (_shouldShowField('type'))
                _buildDetailChip(
                  'Type',
                  _getTransactionType(transaction.toMap()['type']),
                ),
              if (_shouldShowField('actualPrincipalPaymentAmount'))
                _buildDetailChip(
                  'Principal',
                  _formatCurrency(transaction.actualPrincipalPaymentAmount),
                ),
              if (_shouldShowField('actualInterestPaymentAmount'))
                _buildDetailChip(
                  'Interest',
                  _formatCurrency(transaction.actualInterestPaymentAmount),
                ),
              if (_shouldShowField('actualFee'))
                _buildDetailChip(
                  'Late Fee',
                  _formatCurrency(transaction.actualFee),
                ),
              if (_shouldShowField('actualPaymentPostDate'))
                _buildDetailChip(
                  'Post Date',
                  _formatDate(transaction.actualPaymentPostDate),
                ),
              if (_shouldShowField('outstandingPrincipalBalance'))
                _buildDetailChip(
                  'Principal Balance',
                  _formatCurrency(transaction.outstandingPrincipalBalance),
                ),
            ],
          ),
        ],
      ),
    );
  }

  bool _shouldShowField(String fieldKey) {
    return visibleFields.contains(fieldKey);
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(
        '$label: $value',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }

  String _getTransactionType(dynamic type) {
    if (type == 1) return 'Payment';
    if (type == 2) return 'Refund';
    return 'Other';
  }
}
