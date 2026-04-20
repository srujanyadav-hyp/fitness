import 'package:equatable/equatable.dart';

/// States emitted by [SplashCubit].
sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// Initial — animations are running, waiting for [DetermineInitialRouteUseCase].
final class SplashAnimating extends SplashState {
  const SplashAnimating();
}

/// Use case resolved: navigate to authentication.
final class SplashNavigateToAuth extends SplashState {
  const SplashNavigateToAuth();
}

/// Use case resolved: navigate to home dashboard.
final class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}
