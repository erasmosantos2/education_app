import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_data_source.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';

class VideoRepositoryImp implements VideoRepository {
  VideoRepositoryImp(this._dataSource);

  final VideoDataSource _dataSource;

  @override
  ResultFuture<void> addVideo(Video video) async {
    try {
      await _dataSource.addVideo(video);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Video>> getVideos(String courseId) async {
    try {
      return Right(await _dataSource.getVideos(courseId));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
