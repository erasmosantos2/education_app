import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failures.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_borading_cubit.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_borading_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnboardingCubit cubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();

    cubit = OnboardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  final tFailure = CacheFailure(
    message: 'Insufficient storege permission',
    statusCode: 4032,
  );

  test('Initial state should be [OnBoardingInitial] ', () {
    expect(cubit.state, const OnBoardingInitial());
  });

  group('cacheFirstTimer', () {
    blocTest<OnboardingCubit, OnBoardingState>(
      'Should emit [CachingFirstTimer, UserCached] when successful',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => const Right(null),
        );
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimer(),
        const UserCached(),
      ],
      verify: (_) {
        verify(() => cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnBoardingState>(
      'Should emit [CachingFirstTimer, OnBoardingError] when unsuccessful ',
      build: () {
        when(() => cacheFirstTimer()).thenAnswer(
          (_) async => Left(
            tFailure,
          ),
        );
        return cubit;
      },
      act: (cubit) => cubit.cacheFirstTimer(),
      expect: () => [
        const CachingFirstTimer(),
        OnBoardingError(tFailure.errorMessage),
      ],
      verify: (_) {
        verify(
          () => cacheFirstTimer(),
        ).called(1);
        verifyNoMoreInteractions(cacheFirstTimer);
      },
    );
  });

  group('CheckIfUserIsFirstTimer', () {
    blocTest<OnboardingCubit, OnBoardingState>(
      'Should emit [checkingIfUserIsFirstTimer, OnBoardingStatus] '
      'when successful ',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => const Right(false));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: false),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );

    blocTest<OnboardingCubit, OnBoardingState>(
      'Should emit [CheckingIfUserIsFirstTimer, OnboardingStatus(true)] '
      'when unsuccessful',
      build: () {
        when(() => checkIfUserIsFirstTimer())
            .thenAnswer((_) async => Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.checkIfUserIsFirstTimer(),
      expect: () => [
        const CheckingIfUserIsFirstTimer(),
        const OnBoardingStatus(isFirstTimer: true),
      ],
      verify: (_) {
        verify(() => checkIfUserIsFirstTimer()).called(1);
        verifyNoMoreInteractions(checkIfUserIsFirstTimer);
      },
    );
  });
}
