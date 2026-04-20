import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/get_onboarding_pages_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required GetOnboardingPagesUseCase getOnboardingPages,
  }) : super(
          OnboardingState(
            pages: getOnboardingPages(),
            currentIndex: 0,
          ),
        );

  void next() {
    if (!state.isLastPage) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void goToPage(int index) {
    if (index >= 0 && index < state.pages.length) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  void skip() {
    emit(state.copyWith(currentIndex: state.pages.length - 1));
  }
}
