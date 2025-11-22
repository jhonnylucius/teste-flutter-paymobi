import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Eventos do Locale
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para mudar o idioma
class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;

  const ChangeLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

/// Evento para carregar o idioma salvo
class LoadSavedLocaleEvent extends LocaleEvent {
  const LoadSavedLocaleEvent();
}
