import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/course/features/videos/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.videoUrl,
    required super.courseId,
    required super.uploadDate,
    super.thumbnail,
    super.thumbnailIsFile = false,
    super.title,
    super.tutor,
  });

  VideoModel.fromMap(Map<String, dynamic> map)
      : super(
          id: map['id'] as String,
          thumbnail: map['thumbnail'] as String?,
          videoUrl: map['videoUrl'] as String,
          title: map['title'] as String?,
          tutor: map['tutor'] as String?,
          courseId: map['courseId'] as String,
          uploadDate: (map['uploadDate'] as Timestamp).toDate(),
          thumbnailIsFile: map['thumbnailIsFile'] as bool,
        );

  VideoModel.empty()
      : this(
          id: '_empty.id',
          videoUrl: '_empty.videoUrl',
          courseId: '_empty.courseId',
          uploadDate: DateTime.now(),
        );

  VideoModel copyWith({
    String? id,
    String? thumbnail,
    String? videoUrl,
    String? title,
    String? tutor,
    String? courseId,
    DateTime? uploadDate,
    bool? thumbnailIsFile,
  }) {
    return VideoModel(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      videoUrl: videoUrl ?? this.videoUrl,
      title: title ?? this.title,
      tutor: tutor ?? this.tutor,
      courseId: courseId ?? this.courseId,
      uploadDate: uploadDate ?? this.uploadDate,
      thumbnailIsFile: thumbnailIsFile ?? this.thumbnailIsFile,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'title': title,
      'tutor': tutor,
      'courseId': courseId,
      'uploadDate': FieldValue.serverTimestamp(),
      'thumbnailIsFile': thumbnailIsFile,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Video(id: $id, thumbnail: $thumbnail, videoUrl: $videoUrl, '
        ' title: $title, tutor: $tutor, courseId: $courseId, '
        ' uploadDate: $uploadDate, thumbnailIsFile: $thumbnailIsFile)';
  }
}
