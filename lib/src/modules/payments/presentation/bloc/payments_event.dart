import 'package:equatable/equatable.dart';

/// Eventos do BLoC de Pagamentos
abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para carregar os pagamentos pela primeira vez
class LoadPaymentsEvent extends PaymentsEvent {
  const LoadPaymentsEvent();
}

/// Evento para atualizar os pagamentos (pull-to-refresh)
class RefreshPaymentsEvent extends PaymentsEvent {
  const RefreshPaymentsEvent();
}

/// Evento para alternar filtros de transações
class ToggleTransactionFilterEvent extends PaymentsEvent {
  final String filterKey;

  const ToggleTransactionFilterEvent(this.filterKey);

  @override
  List<Object?> get props => [filterKey];
}

/// Evento para alternar campos visíveis dos schedules
class ToggleScheduleFieldEvent extends PaymentsEvent {
  final String fieldKey;

  const ToggleScheduleFieldEvent(this.fieldKey);

  @override
  List<Object?> get props => [fieldKey];
}
