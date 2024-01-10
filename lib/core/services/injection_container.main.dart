part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initonBoarding();
  await _initaUth();
  await _initCourse();
}

Future<void> _initaUth() async {
  sl
    ..registerFactory(
      () => AuthBloc(
        signIn: sl(),
        signUp: sl(),
        forgotPassword: sl(),
        updateUser: sl(),
      ),
    )
    ..registerLazySingleton(
      () => ForgotPassword(sl()),
    )
    ..registerLazySingleton(() => SignIn(sl()))
    ..registerLazySingleton(() => SignUp(sl()))
    ..registerLazySingleton(() => UpdateUser(sl()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: sl(),
        cloudStoreClient: sl(),
        dbClient: sl(),
      ),
    )
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}

Future<void> _initonBoarding() async {
  final prefs = await SharedPreferences.getInstance();
  // Feature --> Onboarding
  // Business Logic
  sl
    ..registerFactory(
      () => OnboardingCubit(
        cacheFirstTimer: sl(),
        checkIfUserIsFirstTimer: sl(),
      ),
    )
    ..registerLazySingleton(() => CacheFirstTimer(sl()))
    ..registerLazySingleton(() => CheckIfUserIsFirstTimer(sl()))
    ..registerLazySingleton<OnBoardingRepository>(
      () => OnBoardingRepositoryImpl(sl()),
    )
    ..registerLazySingleton<OnBoardingLocalDatasource>(
      () => OnBoardingLocalDatasourceImpl(sl()),
    )
    ..registerLazySingleton(() => prefs);
}

Future<void> _initCourse() async {
  sl
    ..registerFactory(
      () => CourseCubit(
        addCourse: sl(),
        getCourses: sl(),
      ),
    )
    ..registerLazySingleton(() => AddCourse(sl()))
    ..registerLazySingleton(() => GetCourses(sl()))
    ..registerLazySingleton<CourseRepository>(() => CourseRepositoryImpl(sl()))
    ..registerLazySingleton<CourseRemoteDataSource>(
      () => CourseRemoteDataSourceImpl(
        firestore: sl(),
        storage: sl(),
        auth: sl(),
      ),
    );
}
