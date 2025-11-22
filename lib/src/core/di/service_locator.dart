import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:base_project/src/modules/payments/data/data.dart';
import 'package:base_project/src/modules/payments/domain/domain.dart';
import 'package:base_project/src/modules/payments/infra/infra.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';
import 'package:base_project/src/core/locale/locale_bloc.dart';

/// Service Locator para Injeção de Dependências
/// Utilizando GetIt para gerenciar as dependências da aplicação
final getIt = GetIt.instance;

/// Configura todas as dependências da aplicação
Future<void> setupDependencies() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  // Locale BLoC
  getIt.registerLazySingleton<LocaleBloc>(() => LocaleBloc(getIt()));

  // DataSources
  getIt.registerLazySingleton<PaymentsDataSource>(
    () => PaymentsDatasourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(getIt()),
  );

  // UseCases
  getIt.registerLazySingleton<GetPaymentsUseCase>(
    () => GetPaymentsUseCase(getIt()),
  );

  // BLoCs
  getIt.registerFactory<PaymentsBloc>(
    () => PaymentsBloc(getPaymentsUseCase: getIt()),
  );
}
