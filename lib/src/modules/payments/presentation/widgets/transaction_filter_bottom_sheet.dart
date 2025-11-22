import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// BottomSheet que permite selecionar/deselecionar filtros de transações
class TransactionFilterBottomSheet extends StatelessWidget {
  final List<PaymentsTransactionFilterEntity> availableFilters;
  final List<String> activeFilters;

  const TransactionFilterBottomSheet({
    super.key,
    required this.availableFilters,
    required this.activeFilters,
  });

  static Future<void> show(
    BuildContext context, {
    required List<PaymentsTransactionFilterEntity> availableFilters,
    required List<String> activeFilters,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => BlocProvider.value(
            value: context.read<PaymentsBloc>(),
            child: TransactionFilterBottomSheet(
              availableFilters: availableFilters,
              activeFilters: activeFilters,
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.additionalInformation,
                  style: AppTextStyles.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filters list
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: availableFilters.length,
              itemBuilder: (context, index) {
                final filter = availableFilters[index];

                return BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, state) {
                    final currentActiveFilters =
                        state is PaymentsLoadedState
                            ? state.activeFilters
                            : <String>[];
                    final isActive = currentActiveFilters.contains(filter.key);

                    return CheckboxListTile(
                      title: Text(
                        LocalizationHelper.translateTransactionFilterLabel(
                          context,
                          filter.label,
                        ),
                        style: AppTextStyles.bodyMedium,
                      ),
                      value: isActive,
                      onChanged: (_) {
                        context.read<PaymentsBloc>().add(
                          ToggleTransactionFilterEvent(filter.key),
                        );
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
