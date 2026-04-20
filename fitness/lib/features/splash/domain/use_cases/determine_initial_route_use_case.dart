/// Domain-layer use case: decides where the app should navigate after
/// the splash screen completes its animation.
///
/// Pure Dart — zero Flutter / external dependencies.
/// Returns a [SplashDestination] enum so the Presentation layer can act.
enum SplashDestination {
  /// User is not authenticated → show login / onboarding.
  auth,

  /// User is already logged in → show home dashboard.
  home,
}

class DetermineInitialRouteUseCase {
  const DetermineInitialRouteUseCase();

  /// Call this after the splash animation finishes.
  /// Inject auth-repository later; for now it always routes to [auth].
  Future<SplashDestination> call() async {
    // TODO: replace with real auth-check from an injected repository.
    // e.g.  final isLoggedIn = await _authRepo.isLoggedIn();
    //       return isLoggedIn ? SplashDestination.home : SplashDestination.auth;
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    return SplashDestination.auth;
  }
}
