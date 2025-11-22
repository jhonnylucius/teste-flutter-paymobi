import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Helper para traduzir labels dinâmicos que vêm do backend
class LocalizationHelper {
  /// Traduz labels dos summary cards
  static String translateSummaryLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;

    switch (label.toLowerCase().replaceAll(' ', '')) {
      case 'outstandingbalance':
        return l10n.outstandingBalance;
      case 'totalpaid':
        return l10n.totalPaid;
      case 'principalpaid':
        return l10n.principalPaid;
      case 'interestpaid':
        return l10n.interestPaid;
      default:
        return label;
    }
  }

  /// Traduz labels dos filtros de transação
  static String translateTransactionFilterLabel(
    BuildContext context,
    String label,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (label.toLowerCase().replaceAll(' ', '')) {
      case 'processdate':
        return l10n.processDate;
      case 'amount':
        return l10n.amount;
      case 'type':
        return l10n.type;
      case 'principal':
        return l10n.principal;
      case 'interest':
        return l10n.interest;
      case 'latefee':
        return l10n.lateFee;
      case 'postdate':
        return l10n.postDate;
      case 'principalbalance':
        return l10n.principalBalance;
      default:
        return label;
    }
  }
}
