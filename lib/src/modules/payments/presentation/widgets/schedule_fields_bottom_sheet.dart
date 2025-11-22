import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Model para os campos disponíveis do Schedule
class ScheduleFieldOption {
  final String key;
  final String Function(BuildContext) labelBuilder;

  const ScheduleFieldOption({required this.key, required this.labelBuilder});

  static List<ScheduleFieldOption> get availableFields => [
    ScheduleFieldOption(
      key: 'paymentDate',
      labelBuilder: (context) => AppLocalizations.of(context)!.paymentDate,
    ),
    ScheduleFieldOption(
      key: 'principal',
      labelBuilder: (context) => AppLocalizations.of(context)!.principal,
    ),
    ScheduleFieldOption(
      key: 'interest',
      labelBuilder: (context) => AppLocalizations.of(context)!.interest,
    ),
    ScheduleFieldOption(
      key: 'total',
      labelBuilder: (context) => AppLocalizations.of(context)!.total,
    ),
    ScheduleFieldOption(
      key: 'outstandingBalance',
      labelBuilder: (context) => AppLocalizations.of(context)!.balance,
    ),
    ScheduleFieldOption(
      key: 'status',
      labelBuilder: (context) => AppLocalizations.of(context)!.status,
    ),
    ScheduleFieldOption(
      key: 'paymentType',
      labelBuilder: (context) => AppLocalizations.of(context)!.paymentType,
    ),
  ];
}

/// BottomSheet que permite selecionar/deselecionar campos visíveis dos schedules
class ScheduleFieldsBottomSheet extends StatelessWidget {
  const ScheduleFieldsBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (modalContext) => BlocProvider.value(
            value: context.read<PaymentsBloc>(),
            child: const ScheduleFieldsBottomSheet(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentsBloc, PaymentsState>(
      builder: (context, state) {
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
                      AppLocalizations.of(context)!.scheduleDetails,
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

              // Fields list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: ScheduleFieldOption.availableFields.length,
                  itemBuilder: (context, index) {
                    final field = ScheduleFieldOption.availableFields[index];

                    return BlocBuilder<PaymentsBloc, PaymentsState>(
                      builder: (context, state) {
                        final currentVisibleFields =
                            state is PaymentsLoadedState
                                ? state.visibleScheduleFields
                                : PaymentsLoadedState.getDefaultScheduleFields();
                        final isVisible = currentVisibleFields.contains(
                          field.key,
                        );

                        return CheckboxListTile(
                          title: Text(
                            field.labelBuilder(context),
                            style: AppTextStyles.bodyMedium,
                          ),
                          value: isVisible,
                          onChanged: (_) {
                            context.read<PaymentsBloc>().add(
                              ToggleScheduleFieldEvent(field.key),
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
      },
    );
  }
}
