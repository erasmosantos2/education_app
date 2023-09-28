import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_auth_repository.dart';

void main() {
  late AuthRepository repository;
  late SignUp usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tFullName = 'test name';

  setUp(() {
    repository = MockAuthRepository();
    usecase = SignUp(repository);
  });

  test('should call the [AuthRepo]', () async {
    when(
      () => repository.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullName: any(named: 'fullName'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(
      const SignUpParams(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    );

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(
      () => repository.signUp(
        email: tEmail,
        password: tPassword,
        fullName: tFullName,
      ),
    ).called(1);
    verifyNoMoreInteractions(repository);
  });
}
