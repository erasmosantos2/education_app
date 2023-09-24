import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateUser implements UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<void> call(UpdateUserParams params) => _repository.updateUser(
        action: params.action,
        userData: params.userdata,
      );
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.action,
    required this.userdata,
  });

  const UpdateUserParams.empty()
      : this(
          action: UpdateUserAction.displayName,
          userdata: '',
        );

  final UpdateUserAction action;
  final dynamic userdata;

  @override
  List<Object?> get props => [action, userdata];
}
