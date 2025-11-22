import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:intl/intl.dart';

/// Item da lista de pagamentos agendados (Schedule)
class ScheduleItem extends StatelessWidget {
  final PaymentsScheduledEntity schedule;
  final List<String> visibleFields;

  const ScheduleItem({
    super.key,
    required this.schedule,
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
      child: Row(
        children: [
          if (_shouldShowField('paymentDate')) _buildDateBadge(),
          if (_shouldShowField('paymentDate'))
            const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_shouldShowField('status'))
                  Text(
                    _getStatusLabel(),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: _getStatusColor(),
                    ),
                  ),
                if (_shouldShowField('status'))
                  const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (_shouldShowField('principal'))
                      _buildDetailChip(
                        'Principal',
                        _formatCurrency(schedule.principal),
                      ),
                    if (_shouldShowField('interest'))
                      _buildDetailChip(
                        'Interest',
                        _formatCurrency(schedule.interest),
                      ),
                    if (_shouldShowField('outstandingBalance'))
                      _buildDetailChip(
                        'Balance',
                        _formatCurrency(schedule.outstandingBalance),
                      ),
                    if (_shouldShowField('paymentType') &&
                        schedule.paymentType.isNotEmpty)
                      _buildDetailChip('Type', schedule.paymentType),
                  ],
                ),
              ],
            ),
          ),
          if (_shouldShowField('total'))
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatCurrency(schedule.total),
                  style: AppTextStyles.transactionAmount,
                ),
                if (schedule.pastDue) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.statusPastDue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                    ),
                    child: Text(
                      'PAST DUE',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.statusPastDue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
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

  Widget _buildDateBadge() {
    final month = DateFormat('MMM').format(schedule.paymentDate).toUpperCase();
    final day = DateFormat('dd').format(schedule.paymentDate);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: AppTextStyles.labelSmall.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            day,
            style: AppTextStyles.titleLarge.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (schedule.pastDue || schedule.status == 'past_due') {
      return AppColors.statusPastDue;
    } else if (schedule.status == 'scheduled') {
      return AppColors.statusScheduled;
    } else if (schedule.status == 'ok') {
      return AppColors.statusOk;
    }
    return AppColors.grey600;
  }

  String _getStatusLabel() {
    if (schedule.pastDue || schedule.status == 'past_due') {
      return 'Past Due';
    } else if (schedule.status == 'scheduled') {
      return 'Scheduled';
    } else if (schedule.status == 'ok') {
      return 'Paid';
    }
    return 'Unknown';
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(value);
  }
}
