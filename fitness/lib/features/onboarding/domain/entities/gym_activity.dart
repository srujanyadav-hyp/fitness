/// Pure Dart domain entity — zero Flutter/UI imports.
///
/// Represents a gym activity shown in the onboarding capacity gauge ticker.
/// [GymActivityType] is used by the presentation layer to resolve icons/assets
/// without polluting the domain with Flutter dependencies.
enum GymActivityType { skipping, cycling, boxing, yoga, zumba }

class GymActivity {
  const GymActivity({
    required this.type,
    required this.label,
    required this.duration,
  });

  final GymActivityType type;

  /// Human-readable activity name, e.g. "Skipping".
  final String label;

  /// Duration string, e.g. "15 min".
  final String duration;
}
