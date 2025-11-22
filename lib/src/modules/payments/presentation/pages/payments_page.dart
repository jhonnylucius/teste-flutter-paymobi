import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Tela principal de Pagamentos com Tabs (Schedule e Transactions)
class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => getIt<PaymentsBloc>()..add(const LoadPaymentsEvent()),
      child: const _PaymentsPageContent(),
    );
  }
}

class _PaymentsPageContent extends StatelessWidget {
  const _PaymentsPageContent();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ResponsiveContainer(
        maxWidth: 800,
        child: Scaffold(
          body: BlocBuilder<PaymentsBloc, PaymentsState>(
            builder: (context, state) {
              if (state is PaymentsLoadingState) {
                return const _LoadingView();
              }

              if (state is PaymentsErrorState) {
                return _ErrorView(message: state.message);
              }

              if (state is PaymentsLoadedState ||
                  state is PaymentsRefreshingState) {
                final paymentsInfo =
                    state is PaymentsLoadedState
                        ? state.paymentsInfo
                        : (state as PaymentsRefreshingState).paymentsInfo;

                final activeFilters =
                    state is PaymentsLoadedState
                        ? state.activeFilters
                        : (state as PaymentsRefreshingState).activeFilters;

                final visibleScheduleFields =
                    state is PaymentsLoadedState
                        ? state.visibleScheduleFields
                        : (state as PaymentsRefreshingState)
                            .visibleScheduleFields;

                return NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      // Corporate Header
                      const SliverToBoxAdapter(child: _CorporateHeader()),

                      // Page Title
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg,
                            AppSpacing.lg,
                            AppSpacing.lg,
                            AppSpacing.md,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.payments,
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Summary Cards
                      SliverToBoxAdapter(
                        child: _SummarySection(summary: paymentsInfo.summary),
                      ),

                      // "Do you want to make a payment?"
                      const SliverToBoxAdapter(child: _PaymentPrompt()),

                      // Tabs
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _TabBarDelegate(
                          TabBar(
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.schedule),
                              Tab(
                                text:
                                    AppLocalizations.of(context)!.transactions,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _ScheduleTab(
                        paymentsInfo: paymentsInfo,
                        visibleFields: visibleScheduleFields,
                        isRefreshing: state is PaymentsRefreshingState,
                      ),
                      _TransactionsTab(
                        paymentsInfo: paymentsInfo,
                        activeFilters: activeFilters,
                        isRefreshing: state is PaymentsRefreshingState,
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

/// Seção de Summary Cards
class _SummarySection extends StatelessWidget {
  final List<PaymentsSummaryEntity> summary;

  const _SummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: summary.length > 4 ? 4 : summary.length,
        itemBuilder: (context, index) => SummaryCard(summary: summary[index]),
      ),
    );
  }
}

/// Widget "Do you want to make a payment?"
class _PaymentPrompt extends StatelessWidget {
  const _PaymentPrompt();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.doYouWantToMakePayment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Em Desenvolvimento'),
                      content: const Text(
                        'Esta funcionalidade estará disponível em breve. '
                        'Estamos trabalhando para trazer a melhor experiência de pagamento para você!',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            },
            child: Text(
              l10n.clickHere,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// View de Loading com Shimmer
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Summary Cards Shimmer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: List.generate(4, (index) => const SummaryCardShimmer()),
            ),
          ),

          // List Items Shimmer
          ...List.generate(6, (index) => const TransactionItemShimmer()),
        ],
      ),
    );
  }
}

/// View de Erro
class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: AppSpacing.giant,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ElevatedButton(
              onPressed: () {
                context.read<PaymentsBloc>().add(const LoadPaymentsEvent());
              },
              child: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab de Schedule (Pagamentos Agendados)
class _ScheduleTab extends StatelessWidget {
  final PaymentsInfoEntity paymentsInfo;
  final List<String> visibleFields;
  final bool isRefreshing;

  const _ScheduleTab({
    required this.paymentsInfo,
    required this.visibleFields,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    // Obtém os schedules já ordenados (próximo pagamento primeiro)
    final schedules = List<PaymentsScheduledEntity>.from(
      paymentsInfo.paymentsScheduled,
    )..sort((a, b) => a.paymentDate.compareTo(b.paymentDate));

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PaymentsBloc>().add(const RefreshPaymentsEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child:
          schedules.isEmpty
              ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: EmptyStateWidget(
                  message: AppLocalizations.of(context)!.emptyScheduleMessage,
                ),
              )
              : CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Header com botão de filtro
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                        vertical: AppSpacing.md,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.paymentSchedule,
                            style: AppTextStyles.titleMedium,
                          ),
                          IconButton(
                            onPressed: () {
                              ScheduleFieldsBottomSheet.show(context);
                            },
                            icon: const Icon(
                              Icons.tune,
                              size: AppSpacing.iconMd,
                            ),
                            tooltip: AppLocalizations.of(context)!.details,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Lista de schedules
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      // Encontra o índice do primeiro schedule futuro (scheduled e não past due)
                      final nextScheduleIndex = schedules.indexWhere(
                        (s) => s.status == 'scheduled' && !s.pastDue,
                      );

                      // Apenas o primeiro schedule futuro recebe o badge "Next"
                      final isNext =
                          index == nextScheduleIndex && nextScheduleIndex != -1;

                      return ScheduleItemSimple(
                        schedule: schedules[index],
                        visibleFields: visibleFields,
                        showNextBadge: isNext,
                      );
                    }, childCount: schedules.length),
                  ),
                  // Padding generoso no final para edge-to-edge
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 80,
                    ),
                  ),
                ],
              ),
    );
  }
}

/// Tab de Transactions (Transações)
class _TransactionsTab extends StatelessWidget {
  final PaymentsInfoEntity paymentsInfo;
  final List<String> activeFilters;
  final bool isRefreshing;

  const _TransactionsTab({
    required this.paymentsInfo,
    required this.activeFilters,
    this.isRefreshing = false,
  });

  @override
  Widget build(BuildContext context) {
    // Obtém as transações já ordenadas (mais recente primeiro)
    final transactions = List<PaymentsTransactionsEntity>.from(
      paymentsInfo.transactions,
    )..sort((a, b) => b.processDate.compareTo(a.processDate));

    final filters = paymentsInfo.transactionFilter;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<PaymentsBloc>().add(const RefreshPaymentsEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // Filter Button
          if (filters.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.transactionHistory,
                      style: AppTextStyles.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {
                        TransactionFilterBottomSheet.show(
                          context,
                          availableFilters: filters,
                          activeFilters: activeFilters,
                        );
                      },
                      icon: const Icon(Icons.tune, size: AppSpacing.iconMd),
                      tooltip: AppLocalizations.of(context)!.filterTransactions,
                    ),
                  ],
                ),
              ),
            ),

          // Transactions List
          if (transactions.isEmpty)
            SliverFillRemaining(
              child: EmptyStateWidget(
                message: AppLocalizations.of(context)!.emptyTransactionsMessage,
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return TransactionItemSimple(
                  transaction: transactions[index],
                  visibleFields: activeFilters,
                );
              }, childCount: transactions.length),
            ),
          // Padding generoso no final para edge-to-edge
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
          ),
        ],
      ),
    );
  }
}

/// Delegate para a TabBar dentro do SliverPersistentHeader
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}

/// Header Corporativo com logo da PayMobi
class _CorporateHeader extends StatelessWidget {
  const _CorporateHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Image.asset(
              '.github/assets/paymobi-logo.png',
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  'PAYMOBI',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),

            // Language & User Menu
            Row(
              children: [
                // Language Selector
                PopupMenuButton<Locale>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  tooltip: AppLocalizations.of(context)!.language,
                  onSelected: (locale) {
                    context.read<LocaleBloc>().add(ChangeLocaleEvent(locale));
                  },
                  itemBuilder:
                      (context) => const [
                        PopupMenuItem(value: Locale('pt'), child: Text('🇧🇷')),
                        PopupMenuItem(value: Locale('en'), child: Text('🇺🇸')),
                      ],
                ),

                // User Menu
                IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Em Desenvolvimento'),
                            content: const Text(
                              'O menu de perfil estará disponível em breve. '
                              'Em breve você poderá gerenciar suas informações e preferências!',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
