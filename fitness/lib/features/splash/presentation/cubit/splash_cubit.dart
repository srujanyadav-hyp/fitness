import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/determine_initial_route_use_case.dart';
import 'splash_state.dart';

/// Drives the splash screen lifecycle.
///
/// Presentation → Domain communication:
///   [SplashCubit] calls [DetermineInitialRouteUseCase] and emits
///   [SplashNavigateToAuth] or [SplashNavigateToHome].
class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required DetermineInitialRouteUseCase determineInitialRoute,
  })  : _determineInitialRoute = determineInitialRoute,
        super(const SplashAnimating());

  final DetermineInitialRouteUseCase _determineInitialRoute;

  /// Called once the splash screen mounts. Triggers the use case and
  /// emits the appropriate navigation state when ready.
  Future<void> start() async {
    final destination = await _determineInitialRoute();
    switch (destination) {
      case SplashDestination.auth:
        emit(const SplashNavigateToAuth());
      case SplashDestination.home:
        emit(const SplashNavigateToHome());
    }
  }
}
