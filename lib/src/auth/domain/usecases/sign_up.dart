import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUp implements UsecaseWithParams<void, CreateUserParams> {
  const SignUp(
    this._repository,
  );
  final AuthRepository _repository;

  @override
  ResultFuture<void> call(CreateUserParams params) => _repository.signUp(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
      );
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.email,
    required this.password,
    required this.fullName,
  });

  const CreateUserParams.empty()
      : this(
          email: '',
          password: '',
          fullName: '',
        );

  final String email;
  final String password;
  final String fullName;

  @override
  List<Object?> get props => [email, password, fullName];
}
