import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'payments_event.dart';
import 'payments_state.dart';

/// BLoC responsável pelo gerenciamento de estado dos pagamentos
class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final GetPaymentsUseCase _getPaymentsUseCase;

  PaymentsBloc({required GetPaymentsUseCase getPaymentsUseCase})
    : _getPaymentsUseCase = getPaymentsUseCase,
      super(const PaymentsInitialState()) {
    on<LoadPaymentsEvent>(_onLoadPayments);
    on<RefreshPaymentsEvent>(_onRefreshPayments);
    on<ToggleTransactionFilterEvent>(_onToggleTransactionFilter);
    on<ToggleScheduleFieldEvent>(_onToggleScheduleField);
  }

  /// Carrega os pagamentos pela primeira vez
  Future<void> _onLoadPayments(
    LoadPaymentsEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    emit(const PaymentsLoadingState());

    final result = await _getPaymentsUseCase();

    result.fold(
      (failure) => emit(PaymentsErrorState(_getErrorMessage(failure))),
      (paymentsInfo) {
        // Inicializa com os filtros padrão (isDefault = true)
        final defaultFilters =
            paymentsInfo.transactionFilter
                .where((filter) => filter.isDefault)
                .map((filter) => filter.key)
                .toList();

        emit(
          PaymentsLoadedState(
            paymentsInfo: paymentsInfo,
            activeFilters: defaultFilters,
            visibleScheduleFields:
                PaymentsLoadedState.getDefaultScheduleFields(),
          ),
        );
      },
    );
  }

  /// Atualiza os pagamentos (pull-to-refresh)
  Future<void> _onRefreshPayments(
    RefreshPaymentsEvent event,
    Emitter<PaymentsState> emit,
  ) async {
    // Mantém o estado atual enquanto carrega
    if (state is PaymentsLoadedState) {
      final currentState = state as PaymentsLoadedState;
      emit(
        PaymentsRefreshingState(
          paymentsInfo: currentState.paymentsInfo,
          activeFilters: currentState.activeFilters,
          visibleScheduleFields: currentState.visibleScheduleFields,
        ),
      );
    }

    final result = await _getPaymentsUseCase();

    result.fold(
      (failure) {
        // Em caso de erro no refresh, volta para o estado loaded anterior
        if (state is PaymentsRefreshingState) {
          final refreshingState = state as PaymentsRefreshingState;
          emit(
            PaymentsLoadedState(
              paymentsInfo: refreshingState.paymentsInfo,
              activeFilters: refreshingState.activeFilters,
              visibleScheduleFields: refreshingState.visibleScheduleFields,
            ),
          );
        } else {
          emit(PaymentsErrorState(_getErrorMessage(failure)));
        }
      },
      (paymentsInfo) {
        final currentFilters =
            state is PaymentsRefreshingState
                ? (state as PaymentsRefreshingState).activeFilters
                : paymentsInfo.transactionFilter
                    .where((filter) => filter.isDefault)
                    .map((filter) => filter.key)
                    .toList();

        final currentScheduleFields =
            state is PaymentsRefreshingState
                ? (state as PaymentsRefreshingState).visibleScheduleFields
                : PaymentsLoadedState.getDefaultScheduleFields();

        emit(
          PaymentsLoadedState(
            paymentsInfo: paymentsInfo,
            activeFilters: currentFilters,
            visibleScheduleFields: currentScheduleFields,
          ),
        );
      },
    );
  }

  /// Alterna um filtro de transação (ativa/desativa)
  void _onToggleTransactionFilter(
    ToggleTransactionFilterEvent event,
    Emitter<PaymentsState> emit,
  ) {
    if (state is PaymentsLoadedState) {
      final currentState = state as PaymentsLoadedState;
      final activeFilters = List<String>.from(currentState.activeFilters);

      if (activeFilters.contains(event.filterKey)) {
        activeFilters.remove(event.filterKey);
      } else {
        activeFilters.add(event.filterKey);
      }

      emit(currentState.copyWith(activeFilters: activeFilters));
    }
  }

  /// Alterna um campo visível do schedule (ativa/desativa)
  void _onToggleScheduleField(
    ToggleScheduleFieldEvent event,
    Emitter<PaymentsState> emit,
  ) {
    if (state is PaymentsLoadedState) {
      final currentState = state as PaymentsLoadedState;
      final visibleFields = List<String>.from(
        currentState.visibleScheduleFields,
      );

      if (visibleFields.contains(event.fieldKey)) {
        visibleFields.remove(event.fieldKey);
      } else {
        visibleFields.add(event.fieldKey);
      }

      emit(currentState.copyWith(visibleScheduleFields: visibleFields));
    }
  }

  /// Retorna mensagem de erro amigável baseada no tipo de falha
  String _getErrorMessage(Failure failure) {
    if (failure is GenericFailure) {
      return AppConstants.genericError001;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
