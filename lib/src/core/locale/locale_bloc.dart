import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_event.dart';
import 'locale_state.dart';

/// BLoC para gerenciar o idioma da aplicação
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String _localeKey = 'selected_locale';
  final SharedPreferences _prefs;

  LocaleBloc(this._prefs) : super(const LocaleLoaded(Locale('pt'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadSavedLocaleEvent>(_onLoadSavedLocale);
  }

  /// Carrega o idioma salvo
  Future<void> _onLoadSavedLocale(
    LoadSavedLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    try {
      final savedLocale = _prefs.getString(_localeKey);
      if (savedLocale != null) {
        emit(LocaleLoaded(Locale(savedLocale)));
      } else {
        // Default para português
        emit(const LocaleLoaded(Locale('pt')));
      }
    } catch (e) {
      // Em caso de erro, mantém português como padrão
      emit(const LocaleLoaded(Locale('pt')));
    }
  }

  /// Muda o idioma e salva a preferência
  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await _prefs.setString(_localeKey, event.locale.languageCode);
    emit(LocaleLoaded(event.locale));
  }
}
