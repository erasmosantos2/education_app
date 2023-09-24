import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDatasource {}

void main() {
  late OnBoardingLocalDatasource datasource;
  late OnBoardingRepository repository;

  setUp(() {
    datasource = MockOnBoardingLocalDataSource();
    repository = OnBoardingRepositoryImpl(datasource);
  });

  test('Should be a subclass of [OnBoardingRepository]', () {
    expect(repository, isA<OnBoardingRepository>());
  });

  group('cacheFirstTimer', () {
    test(
        'Should complete successfully '
        'when call to local source is successfull', () async {
      when(() => datasource.cacheFirstTimer())
          .thenAnswer((_) async => Future.value());

      final result = await repository.cacheFirstTimer();

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => datasource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test(
        'Should return [CacheFailure] when call to local source is '
        'unsuccessful ', () async {
      when(() => datasource.cacheFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient storage'),
      );

      final result = await repository.cacheFirstTimer();

      expect(
        result,
        Left<Failure, dynamic>(
          CacheFailure(message: 'Insufficient storage', statusCode: 500),
        ),
      );
      verify(() => datasource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });

  group('CheckIfUserIsFirstTimer', () {
    test('Should return [true] when user is first timer', () async {
      when(() => datasource.checkIfUseridFirstTimer())
          .thenAnswer((_) async => Future.value(true));
      final result = await repository.checkIfUserIsFirstTimer();

      expect(result, equals(const Right<dynamic, bool>(true)));
      verify(() => datasource.checkIfUseridFirstTimer()).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test('Should return [false] when user is not first timer', () async {
      when(() => datasource.checkIfUseridFirstTimer())
          .thenAnswer((_) async => Future.value(false));

      final result = await repository.checkIfUserIsFirstTimer();

      expect(result, equals(const Right<dynamic, bool>(false)));
      verify(
        () => datasource.checkIfUseridFirstTimer(),
      );
      verifyNoMoreInteractions(datasource);
    });

    test(
        'Should return a CacheFailure when call to local source '
        'is unsuccess', () async {
      when(() => datasource.checkIfUseridFirstTimer()).thenThrow(
        const CacheException(
          message: 'Insufficient permissions',
          statusCode: 403,
        ),
      );
      final result = await repository.checkIfUserIsFirstTimer();
      expect(
        result,
        Left<CacheFailure, bool>(
          CacheFailure(
            message: 'Insufficient permissions',
            statusCode: 403,
          ),
        ),
      );
    });
  });
}
