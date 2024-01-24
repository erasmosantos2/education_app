import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';

class GetVideos extends UsecaseWithParams<List<Video>, String> {
  const GetVideos(this._repository);

  final VideoRepository _repository;

  @override
  ResultFuture<List<Video>> call(String params) =>
      _repository.getVideos(params);
}
