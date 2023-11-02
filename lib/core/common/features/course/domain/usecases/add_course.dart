import 'package:education_app/core/common/features/course/domain/entities/course.dart';
import 'package:education_app/core/common/features/course/domain/repositories/course_repository.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';

class AddCourse extends UsecaseWithParams<void, Course> {
  const AddCourse(this.repository);

  final CourseRepository repository;

  @override
  ResultFuture<void> call(Course params) async => repository.addCourse(params);
}
