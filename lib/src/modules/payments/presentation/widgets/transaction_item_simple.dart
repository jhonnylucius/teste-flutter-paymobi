import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Item da lista de transações - Versão simplificada conforme Figma
class TransactionItemSimple extends StatelessWidget {
  final PaymentsTransactionsEntity transaction;
  final List<String> visibleFields;

  const TransactionItemSimple({
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
          // Process Date e Amount - primeiros campos sempre destacados
          if (_shouldShowField('processDate') &&
              _shouldShowField('actualPaymentAmount'))
            _buildRow(
              context,
              AppLocalizations.of(context)!.processDate,
              _formatDate(transaction.processDate),
              AppLocalizations.of(context)!.amount,
              _formatCurrency(transaction.actualPaymentAmount),
            )
          else if (_shouldShowField('processDate'))
            _buildSingleRow(
              context,
              AppLocalizations.of(context)!.processDate,
              _formatDate(transaction.processDate),
            )
          else if (_shouldShowField('actualPaymentAmount'))
            _buildSingleRow(
              context,
              AppLocalizations.of(context)!.amount,
              _formatCurrency(transaction.actualPaymentAmount),
            ),

          // Type
          if (_shouldShowField('type'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.type,
                transaction.paymentType,
              ),
            ),

          // Principal
          if (_shouldShowField('actualPrincipalPaymentAmount'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.principal,
                _formatCurrency(transaction.actualPrincipalPaymentAmount),
              ),
            ),

          // Interest
          if (_shouldShowField('actualInterestPaymentAmount'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.interest,
                _formatCurrency(transaction.actualInterestPaymentAmount),
              ),
            ),

          // Late Fee
          if (_shouldShowField('actualFee'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.lateFee,
                transaction.actualFee > 0
                    ? _formatCurrency(transaction.actualFee)
                    : '--',
              ),
            ),

          // Post Date
          if (_shouldShowField('actualPaymentPostDate'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.postDate,
                _formatDate(transaction.actualPaymentPostDate),
              ),
            ),

          // Principal Balance
          if (_shouldShowField('outstandingPrincipalBalance'))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: _buildSingleRow(
                context,
                AppLocalizations.of(context)!.principalBalance,
                _formatCurrency(transaction.outstandingPrincipalBalance),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1, style: AppTextStyles.labelSmall),
              Text(value1, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label2, style: AppTextStyles.labelSmall),
              Text(
                value2,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.labelSmall),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }

  bool _shouldShowField(String fieldKey) {
    // Campos padrão sempre aparecem (conforme definido no mock com isDefault: true)
    // Outros campos só aparecem se estiverem na lista de ativos
    return visibleFields.contains(fieldKey);
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
  }
}
