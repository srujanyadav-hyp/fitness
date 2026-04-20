import '../entities/gym_activity.dart';

/// Returns the ordered list of [GymActivity] items displayed in the
/// onboarding screen 3 capacity-gauge activity ticker.
///
/// This is a pure synchronous use-case; no repository is needed because the
/// data is static domain knowledge for the onboarding flow.
class GetGymActivitiesUseCase {
  const GetGymActivitiesUseCase();

  List<GymActivity> call() => const [
        GymActivity(
          type: GymActivityType.skipping,
          label: 'Skipping',
          duration: '15 min',
        ),
        GymActivity(
          type: GymActivityType.cycling,
          label: 'Cycling',
          duration: '20 min',
        ),
        GymActivity(
          type: GymActivityType.boxing,
          label: 'Boxing',
          duration: '45 min',
        ),
        GymActivity(
          type: GymActivityType.yoga,
          label: 'Yoga',
          duration: '30 min',
        ),
        GymActivity(
          type: GymActivityType.zumba,
          label: 'Zumba',
          duration: '60 min',
        ),
      ];
}
