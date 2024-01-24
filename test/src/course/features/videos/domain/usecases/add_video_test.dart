import 'package:dartz/dartz.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';
import 'package:education_app/src/course/features/videos/domain/usecases/add_video.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'video_repository.mock.dart';

void main() {
  late VideoRepository repo;
  late AddVideo usecase;

  final tVideo = Video.empty();

  setUp(() {
    repo = MockVideoRepository();
    usecase = AddVideo(repo);
    registerFallbackValue(tVideo);
  });

  group('AddVideo', () {
    test('should call [videoRepository.addVideo]', () async {
      when(() => repo.addVideo(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tVideo);

      expect(result, const Right<dynamic, void>(null));
      verify(() => repo.addVideo(tVideo)).called(1);
      verifyNoMoreInteractions(repo);
    });
  });
}
