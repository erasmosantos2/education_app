import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repository.dart';

class GetCourses extends UsecaseWithoutParams<List<Course>> {
  const GetCourses(this.repository);

  final CourseRepository repository;

  @override
  ResultFuture<List<Course>> call() async => repository.getCourses();
}
