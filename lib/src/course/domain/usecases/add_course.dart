import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repository.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this.repository);

  final CourseRepository repository;

  @override
  ResultFuture<void> call(Course params) async => repository.addCourse(params);
}
