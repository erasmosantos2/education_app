import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/auth/data/models/user_model.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_event.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockForgotPasswrod extends Mock implements ForgotPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ForgotPassword forgotPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignInParams = SignInParams.empty();
  const tSignUpParams = SignUpParams.empty();
  const tForgotParams = 'email';
  const tUpdateParams = UpdateUserParams.empty();

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    forgotPassword = MockForgotPasswrod();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      forgotPassword: forgotPassword,
      updateUser: updateUser,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tForgotParams);
    registerFallbackValue(tUpdateParams);
  });

  tearDown(() => authBloc.close());

  test('InitialState should be [AuthInitial]', () {
    expect(authBloc.state, const AuthInitial());
  });

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when '
      '[SignInEvent] is added',
      build: () {
        when(
          () => signIn(any()),
        ).thenAnswer((_) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => [const AuthLoading(), const SignedIn(tUser)],
      verify: (_) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn fails',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignUpParams.password,
        ),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(
          () => signIn(tSignInParams),
        ).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('signUp', () {
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, SignedUp] when SignUpEvent is added',
      build: () {
        when(
          () => signUp(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const SignedUp(),
      ],
      verify: (_) {
        verify(
          () => signUp(tSignUpParams),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthRrror] when SignUpEvent is added',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignUpParams.email,
          password: tSignUpParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(
          () => signUp(tSignUpParams),
        ).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    group('forgotPasswrod', () {
      blocTest<AuthBloc, AuthState>(
        'Should emit [AuthLoading, ForgotPasswordSend] '
        'when [ForgotPasswordEvent] is added and forgorPassword successful',
        build: () {
          when(() => forgotPassword(any()))
              .thenAnswer((_) async => const Right(null));
          return authBloc;
        },
        act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
        expect: () => [const AuthLoading(), const ForgotPasswordSent()],
        verify: (_) {
          verify(
            () => forgotPassword('email'),
          ).called(1);
          verifyNoMoreInteractions(forgotPassword);
        },
      );
    });

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, authError] '
      'when forgotPasswordEvent is added',
      build: () {
        when(
          () => forgotPassword(any()),
        ).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ForgotPasswordEvent('email')),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
      verify: (_) {
        verify(
          () => forgotPassword('email'),
        ).called(1);
        verifyNoMoreInteractions(forgotPassword);
      },
    );
  });

  group('updateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, updatedUser] when '
      ' UpdateUserEvent is added and successful ',
      build: () {
        when(
          () => updateUser(any()),
        ).thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateParams.action,
          userData: tUpdateParams.userdata,
        ),
      ),
      expect: () => [const AuthLoading(), const UserUpdated()],
      verify: (_) {
        verify(
          () => updateUser(tUpdateParams),
        ).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'Should emit [AuthLoading, AuthError] is added',
      build: () {
        when(() => updateUser(any())).thenAnswer(
          (_) async => Left(tServerFailure),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateParams.action,
          userData: tUpdateParams.userdata,
        ),
      ),
      expect: () =>
          [const AuthLoading(), AuthError(tServerFailure.errorMessage)],
    );
  });
}
