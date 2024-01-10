import 'package:education_app/src/course/data/datasources/course_remote_data_source.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late CourseRemoteDataSource datasource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  setUp(() async {
    firestore = FakeFirebaseFirestore();
    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );
    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    storage = MockFirebaseStorage();

    datasource = CourseRemoteDataSourceImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );
  });

  group('addCourse', () {
    test('should add the given course to the firestore collection', () async {
      // Arrage
      final course = CourseModel.empty();
      // Act
      await datasource.addCourse(course);

      // Assert
      final fireStoreData = await firestore.collection('courses').get();
      expect(fireStoreData.docs.length, 1);

      final courseRef = fireStoreData.docs.first;
      expect(courseRef.data()['id'], courseRef.id);

      final groupData = await firestore.collection('groups').get();
      expect(groupData.docs.length, 1);

      final groupRef = groupData.docs.first;
      expect(groupRef.data()['id'], groupRef.id);

      expect(courseRef.data()['groupId'], groupRef.id);
      expect(groupRef.data()['courseId'], courseRef.id);
    });
  });

  group('getCourses', () {
    test('Should return a List<Course> when the call is successful', () async {
      // Arrange
      final firstDate = DateTime.now();
      final secondDate = DateTime.now().add(const Duration(seconds: 8));
      final exepectedCourse = [
        CourseModel.empty().copyWith(createdAt: firstDate),
        CourseModel.empty().copyWith(
          createdAt: secondDate,
          id: '1',
          title: 'Course 1',
        ),
      ];

      for (final course in exepectedCourse) {
        await firestore.collection('courses').add(course.toMap());
      }

      // Act
      final result = await datasource.getCourses();

      expect(result, exepectedCourse);
    });
  });
}
