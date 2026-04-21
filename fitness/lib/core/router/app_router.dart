import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/customer/presentation/screens/customer_home_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/owner/presentation/screens/owner_home_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Route name constants
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AppRoutes {
  AppRoutes._();

  static const String splash     = '/';
  static const String onboarding = '/onboarding';
  static const String login      = '/login';
  static const String otp        = '/otp';
  static const String signup     = '/signup';
  static const String customer   = '/customer';
  static const String owner      = '/owner';
}

// ─────────────────────────────────────────────────────────────────────────────
// Singleton repository + cubit — shared across the whole auth flow
// ─────────────────────────────────────────────────────────────────────────────

final AuthRepository _authRepo = FirebaseAuthRepository();
final AuthCubit _authCubit = AuthCubit(repository: _authRepo);

// ─────────────────────────────────────────────────────────────────────────────
// GoRouter
// ─────────────────────────────────────────────────────────────────────────────

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [

    // ── Shared / pre-auth ────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Auth flow ────────────────────────────────────────────────────────────
    //
    // LoginScreen provides AuthCubit. OtpScreen and SignUpScreen inherit
    // it through BlocProvider.value in nested routes.
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: const LoginScreen(),
      ),
      routes: [
        // /login/otp — OTP verification
        GoRoute(
          path: 'otp',
          builder: (context, state) {
            final phone = state.uri.queryParameters['phone'] ?? _authCubit.currentPhone;
            return BlocProvider<AuthCubit>.value(
              value: _authCubit,
              child: OtpScreen(phone: phone),
            );
          },
        ),

        // /login/signup — new user sign-up + role selection
        GoRoute(
          path: 'signup',
          builder: (context, state) {
            final phone = state.uri.queryParameters['phone'] ?? '';
            return BlocProvider<AuthCubit>.value(
              value: _authCubit,
              child: SignUpScreen(phone: phone),
            );
          },
        ),
      ],
    ),

    // ── Customer shell ───────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.customer,
      builder: (context, state) => BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: const CustomerHomeScreen(),
      ),
    ),

    // ── Owner shell ──────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.owner,
      builder: (context, state) => BlocProvider<AuthCubit>.value(
        value: _authCubit,
        child: const OwnerHomeScreen(),
      ),
    ),
  ],
);
