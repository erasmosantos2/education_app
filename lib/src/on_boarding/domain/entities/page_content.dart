import 'package:education_app/core/res/media_res.dart';
import 'package:equatable/equatable.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: 'brand new curriculum.',
          description: 'this is the first online  '
              "education platform designed by the world's top professor ",
        );

  const PageContent.secund()
      : this(
          image: MediaRes.casualLife,
          title: 'Brand a fun atmosphere',
          description: 'this is the first online  '
              "education platform designed by the world's top professor ",
        );

  const PageContent.third()
      : this(
          image: MediaRes.casualMeditation,
          title: 'Easy to join the lesson',
          description: 'this is the first online  '
              "education platform designed by the world's top professor ",
        );

  final String image;
  final String title;
  final String description;

  @override
  List<Object?> get props => [image, title, description];
}
