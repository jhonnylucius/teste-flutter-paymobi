import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Estados do Locale
abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object?> get props => [];
}

/// Estado com locale definido
class LocaleLoaded extends LocaleState {
  final Locale locale;

  const LocaleLoaded(this.locale);

  @override
  List<Object?> get props => [locale];
}
