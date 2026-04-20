/// Domain-layer model: one page of the onboarding flow.
/// Pure Dart — no Flutter imports.
class OnboardingPage {
  const OnboardingPage({
    required this.index,
    required this.headline,
    required this.body,
  });

  final int index;
  final String headline;
  final String body;
}

/// Use case: returns the ordered list of onboarding pages.
/// Keeping it in the domain layer makes it trivially swappable
/// (e.g. fetched from remote config later).
class GetOnboardingPagesUseCase {
  const GetOnboardingPagesUseCase();

  List<OnboardingPage> call() => const [
        OnboardingPage(
          index: 0,
          headline: 'Find gyms near you instantly.',
          body:
              'Discover hundreds of gyms, studios and fitness centres around you.',
        ),
        OnboardingPage(
          index: 1,
          headline: 'Book in 3 taps.\nNo calls needed.',
          body:
              'Day passes, monthly plans, group classes — all bookable from your screen.',
        ),
        OnboardingPage(
          index: 2,
          headline: 'Know before you go.',
          body:
              'See real-time crowd levels so you always get the best workout experience.',
        ),
      ];
}
