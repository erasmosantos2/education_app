import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/data/datasources/course_remote_data_source.dart';
import 'package:education_app/src/course/domain/entities/course.dart';
import 'package:education_app/src/course/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  const CourseRepositoryImpl(
    this._datasource,
  );
  final CourseRemoteDataSource _datasource;

  @override
  ResultFuture<void> addCourse(Course course) async {
    try {
      await _datasource.addCourse(course);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Course>> getCourses() async {
    try {
      final result = await _datasource.getCourses();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
