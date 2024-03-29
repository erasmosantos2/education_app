part of 'router.dart';

Route<dynamic> generateRouter(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      final pref = sl<SharedPreferences>();
      return _pageBuilder(
        (context) {
          if (pref.getBool(kFirstTimerKey) ?? true) {
            return BlocProvider(
              create: (_) => sl<OnboardingCubit>(),
              child: const OnBoardingScreen(),
            );
          } else if (sl<FirebaseAuth>().currentUser != null) {
            final user = sl<FirebaseAuth>().currentUser!;
            final localUser = LocalUserModel(
              uid: user.uid,
              email: user.email ?? '',
              points: 0,
              fullName: user.displayName ?? '',
            );
            context.userProvider.initUser(localUser);
            return const DashBoard();
          } else {
            return BlocProvider(
              create: (_) => sl<AuthBloc>(),
              child: const SignInScreen(),
            );
          }
        },
        settings: settings,
      );
    case SignInScreen.routeName:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.routeName:
      return _pageBuilder(
        (_) {
          return BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const SignUpScreen(),
          );
        },
        settings: settings,
      );
    case DashBoard.routeName:
      return _pageBuilder(
        (_) => const DashBoard(),
        settings: settings,
      );
    case 'forgot-password':
      return _pageBuilder(
        (_) => const fui.ForgotPasswordScreen(),
        settings: settings,
      );
    case CourseDetailsScreen.routeName:
      return _pageBuilder(
        (_) => CourseDetailsScreen(settings.arguments! as Course),
        settings: settings,
      );
    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
