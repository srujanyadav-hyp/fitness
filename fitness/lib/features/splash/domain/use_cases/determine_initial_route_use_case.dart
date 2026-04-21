import 'package:shared_preferences/shared_preferences.dart';

/// Domain-layer use case: decides where the app should navigate after
/// the splash screen completes its animation.
///
/// Reads the SharedPreferences cache written by [FirebaseAuthRepository]
/// on login. No network call — instant decision.
enum SplashDestination {
  /// User is not authenticated → show onboarding / login.
  auth,

  /// User is already logged in → show their role-based home shell.
  home,
}

class DetermineInitialRouteUseCase {
  const DetermineInitialRouteUseCase();

  /// Returns [SplashDestination.home] if a cached auth session exists
  /// in SharedPreferences, otherwise [SplashDestination.auth].
  Future<SplashDestination> call() async {
    // Keep the minimum splash duration for branding.
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('auth_uid');

    return (uid != null && uid.isNotEmpty)
        ? SplashDestination.home
        : SplashDestination.auth;
  }
}
