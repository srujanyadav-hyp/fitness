import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

/// Route name constants.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash      = '/';
  static const String onboarding  = '/onboarding';
  static const String login       = '/login';
  static const String otp         = '/otp';
  static const String signup      = '/signup';
  // Future:
  // static const String customerHome = '/home';
  // static const String ownerHome    = '/owner';
}

/// Singleton GoRouter for FitHub.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    // ── Shared / pre-auth ──────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Auth flow ──────────────────────────────────────────────────────────
    //
    // LoginScreen provides AuthCubit. OtpScreen and SignUpScreen are pushed
    // *inside* the same BlocProvider scope using nested navigation or by
    // reading the cubit from the context when they are pushed via Navigator.
    //
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),

      routes: [
        // /login/otp?phone=+91...
        GoRoute(
          path: 'otp',
          builder: (context, state) {
            final phone = (state.extra as AuthCubit?)?.currentPhone
                ?? state.uri.queryParameters['phone']
                ?? '';
            final cubit = state.extra as AuthCubit?;
            final screen = OtpScreen(phone: phone);
            return cubit != null
                ? BlocProvider<AuthCubit>.value(value: cubit, child: screen)
                : screen;
          },
        ),

        // /login/signup?phone=+91...
        GoRoute(
          path: 'signup',
          builder: (context, state) {
            final phone = state.uri.queryParameters['phone'] ?? '';
            return SignUpScreen(phone: phone);
          },
        ),
      ],
    ),
  ],
);
