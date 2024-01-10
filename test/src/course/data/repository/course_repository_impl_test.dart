import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/data/datasources/course_remote_data_source.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/data/repository/course_repository_impl.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCourseRemoteDataSource extends Mock
    implements CourseRemoteDataSource {}

void main() {
  late CourseRemoteDataSource dataSource;
  late CourseRepository repo;

  final tCourse = CourseModel.empty();

  setUp(() {
    dataSource = MockCourseRemoteDataSource();
    repo = CourseRepositoryImpl(dataSource);
    registerFallbackValue(tCourse);
  });

  const tException = ServerException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addCourse', () {
    test(
        'should complete successfully when call to remote source is successful',
        () async {
      when(() => dataSource.addCourse(any())).thenAnswer(
        (_) async => Future.value(),
      );
      final result = await repo.addCourse(tCourse);

      expect(result, const Right<dynamic, void>(null));
      verify(() => dataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
        'Should return [ServerFailure] when call remote source is '
        ' unsuccessful', () async {
      when(() => dataSource.addCourse(any())).thenThrow(tException);

      final result = await repo.addCourse(tCourse);

      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure.fromException(tException),
        ),
      );
      verify(() => dataSource.addCourse(tCourse)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });

  group('getCourses', () {
    test(
        'should return [List<Course>] when call to remote '
        'source is successful', () async {
      when(() => dataSource.getCourses()).thenAnswer((_) async => [tCourse]);

      final result = await repo.getCourses();

      expect(result, isA<Right<dynamic, List<Course>>>());
    });

    test(
        'should return [ServerFailure] when call  to remote source is '
        ' unsuccessful', () async {
      when(() => dataSource.getCourses()).thenThrow(tException);

      final result = await repo.getCourses();
      expect(
        result,
        Left<Failure, dynamic>(
          ServerFailure(
            message: tException.message,
            statusCode: tException.statusCode,
          ),
        ),
      );
    });
  });
}
