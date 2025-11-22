import 'package:equatable/equatable.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';

/// Estados do BLoC de Pagamentos
abstract class PaymentsState extends Equatable {
  const PaymentsState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class PaymentsInitialState extends PaymentsState {
  const PaymentsInitialState();
}

/// Estado de carregamento
class PaymentsLoadingState extends PaymentsState {
  const PaymentsLoadingState();
}

/// Estado de carregamento com dados existentes (para pull-to-refresh)
class PaymentsRefreshingState extends PaymentsState {
  final PaymentsInfoEntity paymentsInfo;
  final List<String> activeFilters;
  final List<String> visibleScheduleFields;

  const PaymentsRefreshingState({
    required this.paymentsInfo,
    required this.activeFilters,
    required this.visibleScheduleFields,
  });

  @override
  List<Object?> get props => [
    paymentsInfo,
    activeFilters,
    visibleScheduleFields,
  ];
}

/// Estado com dados carregados com sucesso
class PaymentsLoadedState extends PaymentsState {
  final PaymentsInfoEntity paymentsInfo;
  final List<String> activeFilters;
  final List<String> visibleScheduleFields;

  const PaymentsLoadedState({
    required this.paymentsInfo,
    required this.activeFilters,
    required this.visibleScheduleFields,
  });

  /// Retorna as transações ordenadas por data (mais recente primeiro)
  List<PaymentsTransactionsEntity> get sortedTransactions {
    final transactions = List<PaymentsTransactionsEntity>.from(
      paymentsInfo.transactions,
    );

    // Ordena por processDate em ordem decrescente (mais recente primeiro)
    transactions.sort((a, b) => b.processDate.compareTo(a.processDate));

    return transactions;
  }

  /// Retorna os filtros disponíveis
  List<PaymentsTransactionFilterEntity> get availableFilters {
    return paymentsInfo.transactionFilter;
  }

  /// Retorna os filtros padrão (isDefault = true)
  List<String> getDefaultFilters() {
    return paymentsInfo.transactionFilter
        .where((filter) => filter.isDefault)
        .map((filter) => filter.key)
        .toList();
  }

  /// Campos padrão visíveis do schedule
  static List<String> getDefaultScheduleFields() {
    return ['paymentDate', 'principal', 'interest', 'total'];
  }

  PaymentsLoadedState copyWith({
    PaymentsInfoEntity? paymentsInfo,
    List<String>? activeFilters,
    List<String>? visibleScheduleFields,
  }) {
    return PaymentsLoadedState(
      paymentsInfo: paymentsInfo ?? this.paymentsInfo,
      activeFilters: activeFilters ?? this.activeFilters,
      visibleScheduleFields:
          visibleScheduleFields ?? this.visibleScheduleFields,
    );
  }

  @override
  List<Object?> get props => [
    paymentsInfo,
    activeFilters,
    visibleScheduleFields,
  ];
}

/// Estado de erro
class PaymentsErrorState extends PaymentsState {
  final String message;

  const PaymentsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
