import 'package:education_app/core/common/features/course/domain/entities/course.dart';

abstract class CourseRemoteDataSource {
  Future<List<Course>> getCourses();
  Future<void> addCourse(Course course);
}
