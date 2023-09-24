import 'package:dartz/dartz.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_auth_repository.dart';

void main() {
  late AuthRepository repository;
  late ForgotPassword usecase;

  const tEmail = 'Test email';

  setUp(() {
    repository = MockAuthRepository();
    usecase = ForgotPassword(repository);
  });

  test('should call the [AuthRepo.forgotPassword]', () async {
    when(() => repository.forgotPassword(any()))
        .thenAnswer((_) async => const Right(null));

    final result = await usecase(tEmail);

    expect(result, equals(const Right<dynamic, void>(null)));
    verify(() => repository.forgotPassword(tEmail)).called(1);
    verifyNoMoreInteractions(repository);
  });
}
