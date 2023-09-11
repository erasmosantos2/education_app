import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:education_app/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubit/on_borading_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ls = GetIt.instance;

Future<void> init() async {
  final prefs = SharedPreferences.getInstance();
  // Feature --> Onboarding
  // Business Logic
  ls
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: ls(),
        checkIfUserIsFirstTimer: ls(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(ls.get()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(ls.get()))
    ..registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(ls()),
    )
    ..registerLazySingleton<OnBoardingLocalDatasource>(
      () => OnBoardingLocalDatasourceImpl(ls()),
    )
    ..registerLazySingleton(() => prefs);
}
