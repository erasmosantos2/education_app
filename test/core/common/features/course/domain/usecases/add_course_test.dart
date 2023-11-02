import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:education_app/core/common/features/course/domain/usecases/add_course.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repository_mock.dart';

void main() {
  late CourseRepository repo;
  late AddCourse usecase;

  final tCourse = Course.empty();

  setUp(() {
    repo = MockCourseRepository();
    usecase = AddCourse(repo);
    registerFallbackValue(tCourse);
  });

  test('Should call [CourseRepository.addCourse]', () async {
    when(() => repo.addCourse(any())).thenAnswer(
      (_) async => const Right(null),
    );

    await usecase(tCourse);

    verify(() => repo.addCourse(tCourse)).called(1);
  });
}
