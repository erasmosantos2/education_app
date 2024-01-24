import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/course/features/videos/data/datasources/video_data_source.dart';
import 'package:education_app/src/course/features/videos/data/repository/video_repository_imp.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';
import 'package:education_app/src/course/features/videos/domain/repository/video_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockVideoDataSource extends Mock implements VideoDataSource {}

void main() {
  late VideoDataSource datasource;
  late VideoRepository repo;
  final tVideo = Video.empty();

  setUp(() {
    datasource = MockVideoDataSource();
    repo = VideoRepositoryImp(datasource);
    registerFallbackValue(tVideo);
  });

  const tException = ServerException(message: 'message', statusCode: '500');

  group('addVideo', () {
    test(
      'should complete successfully when call to remote source is successful',
      () async {
        when(() => datasource.addVideo(any())).thenAnswer(
          (_) async => Future.value(),
        );

        final result = await repo.addVideo(tVideo);

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(
          () => datasource.addVideo(tVideo),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test(
      'should return a [ServerFailure] when call remote'
      ' source is unsuccessful ',
      () async {
        when(() => datasource.addVideo(any())).thenThrow(
          tException,
        );

        final result = await repo.addVideo(tVideo);

        expect(
          result,
          Left<ServerFailure, dynamic>(
            ServerFailure.fromException(tException),
          ),
        );
      },
    );
  });

  group('getVideos', () {
    test(
        'should return a [List<Video>>] when call to'
        ' remote source is successful', () async {
      when(
        () => datasource.getVideos(any()),
      ).thenAnswer((_) async => [tVideo]);

      final result = await repo.getVideos(tVideo.courseId);

      expect(result, isA<Right<dynamic, List<Video>>>());
      verify(() => datasource.getVideos(tVideo.courseId)).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test(
        'should reutrn [ServerFailure] when call to remote'
        ' datasource is unsuccessful', () async {
      when(() => datasource.getVideos(any())).thenThrow(tException);

      final result = await repo.getVideos(tVideo.courseId);

      expect(
        result,
        Left<dynamic, List<Video>>(ServerFailure.fromException(tException)),
      );
      verify(() => datasource.getVideos(tVideo.courseId)).called(1);
      verifyNoMoreInteractions(datasource);
    });
  });
}
