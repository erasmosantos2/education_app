import 'package:dartz/dartz.dart';
import 'package:education_app/core/common/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:education_app/core/common/features/course/domain/usecases/get_courses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'course_repository_mock.dart';

void main() {
  late CourseRepository repo;
  late GetCourses usecase;

  setUp(() {
    repo = MockCourseRepository();
    usecase = GetCourses(repo);
  });

  test('Should get courses from the repository', () async {
    when(() => repo.getCourses()).thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result, const Right<dynamic, List<Course>>([]));
    verify(() => repo.getCourses()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
