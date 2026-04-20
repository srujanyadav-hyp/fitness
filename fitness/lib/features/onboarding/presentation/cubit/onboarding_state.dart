import 'package:equatable/equatable.dart';
import '../../domain/use_cases/get_onboarding_pages_use_case.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    required this.pages,
    required this.currentIndex,
  });

  final List<OnboardingPage> pages;
  final int currentIndex;

  bool get isLastPage => currentIndex == pages.length - 1;

  OnboardingState copyWith({int? currentIndex}) => OnboardingState(
        pages: pages,
        currentIndex: currentIndex ?? this.currentIndex,
      );

  @override
  List<Object?> get props => [pages, currentIndex];
}
