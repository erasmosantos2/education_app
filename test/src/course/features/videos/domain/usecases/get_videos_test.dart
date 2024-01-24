import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/get_videos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repository.mock.dart';

void main() {
  late VideoRepository repo;
  late GetVideos usecase;

  final tVideo = Video.empty();

  setUp(() {
    repo = MockVideoRepository();
    usecase = GetVideos(repo);
    // registerFallbackValue(tVideos);
  });

  group('GetVideos', () {
    test('should get videos from the repository', () async {
      when(() => repo.getVideos(any()))
          .thenAnswer((_) async => Right([tVideo]));

      final result = await usecase(tVideo.id);

      expect(result, isA<Right<dynamic, List<Video>>>());
      verify(
        () => repo.getVideos(tVideo.id),
      ).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
