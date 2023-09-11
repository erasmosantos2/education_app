import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDatasource datasource;

  setUp(() {
    prefs = MockSharedPreferences();
    datasource = OnBoardingLocalDatasourceImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('Should call [SharedPreferences]  to cache the data', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      await datasource.cacheFirstTimer();

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
        'Should throw a [CacheException] when there is an error '
        'caching the data', () async {
      when(() => prefs.setBool(any(), any())).thenThrow(Exception());
      final methodCall = datasource.cacheFirstTimer;
      expect(
        methodCall,
        throwsA(isA<CacheException>()),
      );
      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });

  group('checkifuserIsFirstTimer', () {
    test(
        'Should call [SharedPreferences] to check if user is first timer and '
        'return the right response from storage when data exists  ', () async {
      when(() => prefs.getBool(any())).thenReturn(false);

      final result = await datasource.checkIfUseridFirstTimer();

      expect(result, false);

      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test('Should return true if there is no data in storegae', () async {
      when(() => prefs.getBool(any())).thenReturn(null);

      final result = await datasource.checkIfUseridFirstTimer();

      expect(result, true);
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });

    test(
        'Should throw a [CachaException] when there is an error '
        'retrieving the data', () async {
      when(() => prefs.getBool(any())).thenThrow(Exception());

      final methodCall = datasource.checkIfUseridFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => prefs.getBool(kFirstTimerKey)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });
}
