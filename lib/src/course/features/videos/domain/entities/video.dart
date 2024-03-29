import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
    required this.id,
    required this.videoUrl,
    required this.courseId,
    required this.uploadDate,
    this.thumbnail,
    this.thumbnailIsFile = false,
    this.title,
    this.tutor,
  });

  Video.empty()
      : this(
          id: '_empty.id',
          videoUrl: '_empty.videoUrl',
          courseId: '_empty.course_id',
          uploadDate: DateTime.now(),
        );

  final String id;
  final String? thumbnail;
  final String videoUrl;
  final String? title;
  final String? tutor;
  final String courseId;
  final DateTime uploadDate;
  final bool thumbnailIsFile;

  @override
  List<Object?> get props => [id];
}
