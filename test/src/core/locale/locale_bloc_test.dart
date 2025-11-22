import 'package:base_project/src/core/locale/locale.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late LocaleBloc bloc;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  tearDown(() {
    bloc.close();
  });

  group('LocaleBloc', () {
    test('initial state should be LocaleLoaded with Portuguese', () {
      // Arrange
      bloc = LocaleBloc(mockPrefs);

      // Assert
      expect(bloc.state, const LocaleLoaded(Locale('pt')));
    });

    blocTest<LocaleBloc, LocaleState>(
      'should emit LocaleLoaded with saved locale when LoadSavedLocaleEvent is triggered',
      build: () {
        when(() => mockPrefs.getString('selected_locale')).thenReturn('en');
        return LocaleBloc(mockPrefs);
      },
      act: (bloc) => bloc.add(const LoadSavedLocaleEvent()),
      expect: () => [const LocaleLoaded(Locale('en'))],
      verify: (_) {
        verify(() => mockPrefs.getString('selected_locale')).called(1);
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'should emit LocaleLoaded with Portuguese when no saved locale exists',
      build: () {
        when(() => mockPrefs.getString('selected_locale')).thenReturn(null);
        return LocaleBloc(mockPrefs);
      },
      act: (bloc) => bloc.add(const LoadSavedLocaleEvent()),
      expect: () => [const LocaleLoaded(Locale('pt'))],
    );

    blocTest<LocaleBloc, LocaleState>(
      'should emit LocaleLoaded with Portuguese on error',
      build: () {
        when(
          () => mockPrefs.getString('selected_locale'),
        ).thenThrow(Exception('Error'));
        return LocaleBloc(mockPrefs);
      },
      act: (bloc) => bloc.add(const LoadSavedLocaleEvent()),
      expect: () => [const LocaleLoaded(Locale('pt'))],
    );

    blocTest<LocaleBloc, LocaleState>(
      'should save and emit new locale when ChangeLocaleEvent is triggered',
      build: () {
        when(
          () => mockPrefs.setString('selected_locale', 'en'),
        ).thenAnswer((_) async => true);
        return LocaleBloc(mockPrefs);
      },
      act: (bloc) => bloc.add(const ChangeLocaleEvent(Locale('en'))),
      expect: () => [const LocaleLoaded(Locale('en'))],
      verify: (_) {
        verify(() => mockPrefs.setString('selected_locale', 'en')).called(1);
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'should change from English to Portuguese',
      build: () {
        when(
          () => mockPrefs.setString('selected_locale', 'pt'),
        ).thenAnswer((_) async => true);
        return LocaleBloc(mockPrefs);
      },
      seed: () => const LocaleLoaded(Locale('en')),
      act: (bloc) => bloc.add(const ChangeLocaleEvent(Locale('pt'))),
      expect: () => [const LocaleLoaded(Locale('pt'))],
      verify: (_) {
        verify(() => mockPrefs.setString('selected_locale', 'pt')).called(1);
      },
    );

    blocTest<LocaleBloc, LocaleState>(
      'should handle multiple locale changes',
      build: () {
        when(
          () => mockPrefs.setString('selected_locale', any()),
        ).thenAnswer((_) async => true);
        return LocaleBloc(mockPrefs);
      },
      act: (bloc) {
        bloc.add(const ChangeLocaleEvent(Locale('en')));
        bloc.add(const ChangeLocaleEvent(Locale('pt')));
        bloc.add(const ChangeLocaleEvent(Locale('en')));
      },
      expect:
          () => [
            const LocaleLoaded(Locale('en')),
            const LocaleLoaded(Locale('pt')),
            const LocaleLoaded(Locale('en')),
          ],
      verify: (_) {
        verify(() => mockPrefs.setString('selected_locale', 'en')).called(2);
        verify(() => mockPrefs.setString('selected_locale', 'pt')).called(1);
      },
    );
  });
}
