import 'package:dartz/dartz.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:education_app/src/auth/domain/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource datasource;
  late AuthRepository repo;

  setUp(() {
    datasource = MockAuthRemoteDataSource();
    repo = AuthRepositoryImpl(datasource);
    registerFallbackValue(UpdateUserAction.password);
  });

  const tEmail = 'eromweb@gmail.com';
  const tPassword = 'tPassword';
  const tName = 'test Name';
  const tUpdateAction = UpdateUserAction.password;
  const tUserData = 'New password';

  const tException = ServerException(
    message: 'User does not exist',
    statusCode: '404',
  );
  const tUser = LocalUserModel.empty();

  group('forgotPassword', () {
    test('should return [void] when call to remote source is successful',
        () async {
      when(() => datasource.forgotPassword(any()))
          .thenAnswer((_) async => Future.value());

      final result = await repo.forgotPassword(tEmail);

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(
        () => datasource.forgotPassword(tEmail),
      ).called(1);
      verifyNoMoreInteractions(datasource);
    });

    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => datasource.forgotPassword(any()),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repo.forgotPassword(tEmail);
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'User does not exist',
              statusCode: '404',
            ),
          ),
        );
        verify(
          () => datasource.forgotPassword(tEmail),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUser] when call to remote source is successful',
      () async {
        when(
          () => datasource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => tUser);

        final result = await repo.signIn(email: tEmail, password: tPassword);

        expect(result, const Right<dynamic, LocalUserModel>(tUser));
        verify(
          () => datasource.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => datasource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result = await repo.signIn(email: tEmail, password: tPassword);
        expect(
          result,
          Left<Failure, dynamic>(
            ServerFailure(
              message: 'User does not exist',
              statusCode: '404',
            ),
          ),
        );
        verify(
          () => datasource.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
  });

  group('signUp', () {
    test(
      'should return [void] when call to remote source is successful',
      () async {
        when(
          () => datasource.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            fullName: any(named: 'fullName'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result = await repo.signUp(
          email: tEmail,
          password: tPassword,
          fullName: tName,
        );

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(
          () => datasource.signUp(
            email: tEmail,
            password: tPassword,
            fullName: tName,
          ),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
    test(
      'should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => datasource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          ServerException(
            message: tException.message,
            statusCode: tException.statusCode,
          ),
        );

        final result = await repo.signIn(email: tEmail, password: tPassword);

        expect(
          result,
          Left<Failure, void>(
            ServerFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          ),
        );
        verify(
          () => datasource.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );
  });

  group('updateUser', () {
    test(
      'Should return [void] when call to remote source is successsful',
      () async {
        when(
          () => datasource.updateUser(
            action: any(named: 'action'),
            userData: any<String>(named: 'userData'),
          ),
        ).thenAnswer((_) async => Future.value());

        final result =
            await repo.updateUser(action: tUpdateAction, userData: tUserData);

        expect(result, const Right<dynamic, void>(null));
        verify(
          () =>
              datasource.updateUser(action: tUpdateAction, userData: tUserData),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    test(
      'Should return [ServerFailure] when call to remote source is '
      'unsuccessful',
      () async {
        when(
          () => datasource.updateUser(
            action: any(named: 'action'),
            userData: any<dynamic>(named: 'userData'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'User does not exist',
            statusCode: '404',
          ),
        );

        final result =
            await repo.updateUser(action: tUpdateAction, userData: tUserData);

        expect(
          result,
          equals(
            Left<Failure, dynamic>(
              ServerFailure(
                message: 'User does not exist',
                statusCode: '404',
              ),
            ),
          ),
        );
        verify(
          () => datasource.updateUser(
            action: tUpdateAction,
            userData: tUserData,
          ),
        ).called(1);
        verifyNoMoreInteractions(datasource);
      },
    );

    // test(
    //   'should return [ServerFailure] when call to remote source is '
    //   'unsuccessful',
    //   () async {
    //     when(
    //       () => datasource.updateUser(
    //         action: any(named: 'action'),
    //         userData: any<dynamic>(named: 'userData'),
    //       ),
    //     ).thenThrow(
    //       const ServerException(
    //         message: 'User does not exist',
    //         statusCode: '404',
    //       ),
    //     );

    //     final result = await repo.updateUser(
    //       action: tUpdateAction,
    //       userData: tUserData,
    //     );

    //     expect(
    //       result,
    //       equals(
    //         Left<Failure, void>(
    //           ServerFailure(
    //             message: 'User does not exist',
    //             statusCode: '404',
    //           ),
    //         ),
    //       ),
    //     );

    //     verify(
    //       () => datasource.updateUser(
    //         action: tUpdateAction,
    //         userData: tUserData,
    //       ),
    //     ).called(1);

    //     verifyNoMoreInteractions(datasource);
    //   },
    // );
  });
}
