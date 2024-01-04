import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.lastMessage,
    super.groupImageUrl,
    super.lastMessageTimestamp,
    super.lastMessageSenderName,
  });

  GroupModel.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: const [],
          lastMessage: '',
          groupImageUrl: '',
          lastMessageSenderName: '',
          lastMessageTimestamp: DateTime.now(),
        );

  GroupModel.fromMap(Map<dynamic, String> map)
      : this(
          id: map['id']!,
          name: map['name']!,
          courseId: map['courseId']!,
          members: List<String>.from(map['members']! as List<dynamic>),
          // OR
          // members: (map['members']! as List<dynamic>).cast<String>(),
          // OR
          // members: (map['members']! as List<dynamic>)
          //     .map((e) => e as String)
          //     .toList(),
          lastMessage: map['lastMessage'],
          lastMessageSenderName: map['lastMessageSenderName'],
          lastMessageTimestamp:
              (map['lastMessageSenderName'] as Timestamp?)?.toDate(),
          groupImageUrl: map['groupImageUrl'],
        );

  GroupModel copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? lastMessage,
    String? groupImageUrl,
    DateTime? lastMessageTimestamp,
    String? lastMessageSenderName,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'members': members,
      'lastMessage': lastMessage,
      'groupImageUrl': groupImageUrl,
      'lastMessageTimestamp':
          lastMessage == null ? null : FieldValue.serverTimestamp(),
      'lastMessageSenderName': lastMessageSenderName,
    };
  }
}
