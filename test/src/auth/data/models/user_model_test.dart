import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();
  late DataMap tMap;

  setUp(() {
    tMap = jsonDecode(fixture('user.json')) as DataMap;
  });

  test('Should to be a subclass [LocalUser] entity', () {
    expect(tLocalUserModel, isA<LocalUser>());
  });

  group('fromMap', () {
    test('Should return a valid [LocalUserModel] from the map', () {
      final result = LocalUserModel.fromMap(tMap);

      expect(result, equals(tLocalUserModel));
      expect(result, isA<LocalUserModel>());
    });

    test('Should throw an [error] when the map is invalid', () {
      // final map = DataMap.from(tMap)..remove('uid');
      final map = tMap..remove('uid');

      const call = LocalUserModel.fromMap;

      expect(() => call(map), throwsA(isA<Error>()));
    });
  });

  group('toMap', () {
    test('Should return a valid [DataMap] from the model', () {
      final result = tLocalUserModel.toMap();

      expect(result, equals(tMap));
      // expect(result, isA<DataMap>());
    });
  });

  group('copyWith', () {
    test('Should return a valid [LocalUserModel] with updated values', () {
      final result = tLocalUserModel.copyWith(uid: '2');

      expect(result.uid, '2');
    });
  });
}
