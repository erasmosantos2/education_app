import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_auth_repository.dart';

void main() {
  late AuthRepository repository;
  late UpdateUser usecase;
  setUp(() {
    repository = MockAuthRepository();
    usecase = UpdateUser(repository);
    registerFallbackValue(UpdateUserAction.email);
  });

  const tParams = UpdateUserParams(
    action: UpdateUserAction.email,
    userdata: '',
  );

  test('should call the [AuthRepo]', () async {
    when(
      () => repository.updateUser(
        action: any(named: 'action'),
        userData: any<dynamic>(named: 'userData'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(tParams);

    expect(
      result,
      equals(
        const Right<dynamic, void>(null),
      ),
    );
    verify(
      () => repository.updateUser(action: UpdateUserAction.email, userData: ''),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
