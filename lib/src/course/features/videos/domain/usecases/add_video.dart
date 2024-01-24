import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';

class AddVideo extends UsecaseWithParams<void, Video> {
  AddVideo(
    this._repository,
  );

  final VideoRepository _repository;

  @override
  ResultFuture<void> call(Video params) async => _repository.addVideo(params);
}
