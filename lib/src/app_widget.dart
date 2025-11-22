import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/splash/splash_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      create:
          (context) => getIt<LocaleBloc>()..add(const LoadSavedLocaleEvent()),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Paymobi Payments',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            locale: state is LocaleLoaded ? state.locale : const Locale('pt'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pt')],
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
