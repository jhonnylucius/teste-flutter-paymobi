import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Item da lista de pagamentos agendados (Schedule) - Versão simplificada conforme Figma
class ScheduleItemSimple extends StatelessWidget {
  final PaymentsScheduledEntity schedule;
  final List<String> visibleFields;
  final bool showNextBadge;

  const ScheduleItemSimple({
    super.key,
    required this.schedule,
    required this.visibleFields,
    this.showNextBadge = false,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data
                if (_shouldShowField('paymentDate'))
                  Text(
                    _formatDate(schedule.paymentDate),
                    style: AppTextStyles.bodyMedium,
                  ),

                // Status
                if (_shouldShowField('status') && schedule.status.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      _getStatusLabel(context),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: _getStatusColor(),
                      ),
                    ),
                  ),

                // Principal
                if (_shouldShowField('principal'))
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      '${AppLocalizations.of(context)!.principal}: ${_formatCurrency(schedule.principal)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),

                // Interest
                if (_shouldShowField('interest'))
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      '${AppLocalizations.of(context)!.interest}: ${_formatCurrency(schedule.interest)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),

                // Outstanding Balance
                if (_shouldShowField('outstandingBalance'))
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      '${AppLocalizations.of(context)!.balance}: ${_formatCurrency(schedule.outstandingBalance)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),

                // Payment Type
                if (_shouldShowField('paymentType') &&
                    schedule.paymentType.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      '${AppLocalizations.of(context)!.type}: ${schedule.paymentType}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
              ],
            ),
          ),

          // Valor + Badge "Next"
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_shouldShowField('total'))
                Text(
                  _formatCurrency(schedule.total),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showNextBadge) ...[
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primaryDark,
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

  String _getStatusLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (schedule.pastDue) return l10n.pastDue;
    switch (schedule.status.toLowerCase()) {
      case 'ok':
        return l10n.paid;
      case 'scheduled':
        return l10n.scheduled;
      case 'past_due':
        return l10n.pastDue;
      default:
        return schedule.status;
    }
  }

  Color _getStatusColor() {
    if (schedule.pastDue) return AppColors.statusPastDue;
    switch (schedule.status.toLowerCase()) {
      case 'ok':
        return AppColors.statusOk;
      case 'scheduled':
        return AppColors.statusScheduled;
      case 'past_due':
        return AppColors.statusPastDue;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String _formatCurrency(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(value);
  }
}
