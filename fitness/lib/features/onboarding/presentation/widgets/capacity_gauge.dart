import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/gym_activity.dart';
import '../../domain/use_cases/get_gym_activities_use_case.dart';


/// Screen 3 illustration: real-time capacity gauge.
///
/// **Animations:**
/// - Arc fills from 0 → 85 % with elastic overshoot on mount
/// - Two blob auras pulse with phase-offset breathing
/// - Gauge number counts up from 0 → 85
/// - Chip heartbeat scale pulse
/// - Activity ticker: slot-machine scroll, new item enters from below,
///   old item exits to the top — loops every 2.5 s
class CapacityGauge extends StatefulWidget {
  const CapacityGauge({super.key});

  @override
  State<CapacityGauge> createState() => _CapacityGaugeState();
}

class _CapacityGaugeState extends State<CapacityGauge>
    with TickerProviderStateMixin {
  // ── Arc fill ───────────────────────────────────────────────────────────────
  late final AnimationController _arcCtrl;
  late final Animation<double> _arcProgress;
  late final Animation<int> _counter;

  // ── Blob auras ─────────────────────────────────────────────────────────────
  late final AnimationController _blob1;
  late final AnimationController _blob2;

  // ── Chip heartbeat ─────────────────────────────────────────────────────────
  late final AnimationController _chipCtrl;
  late final Animation<double> _chipScale;

  // ── Activity ticker ────────────────────────────────────────────────────────
  // Uses a simple Timer + AnimatedSwitcher — no custom AnimationController
  // needed. AnimatedSwitcher handles in/out animations declaratively.
  Timer? _timer;
  int _tickerIndex = 0;

  // Activities fetched once from the domain use-case
  late final List<GymActivity> _activities;

  @override
  void initState() {
    super.initState();

    // Arc fill (0 → 85 %, elastic overshoot)
    _arcCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _arcProgress = Tween<double>(begin: 0, end: 0.85).animate(
      CurvedAnimation(parent: _arcCtrl, curve: Curves.elasticOut),
    );
    _counter = IntTween(begin: 0, end: 85).animate(
      CurvedAnimation(parent: _arcCtrl, curve: Curves.easeOut),
    );
    _arcCtrl.forward();

    // Blob auras
    _blob1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
    _blob2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _blob2.repeat(reverse: true);
    });

    // Chip heartbeat
    _chipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _chipScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _chipCtrl, curve: Curves.easeInOut),
    );

    // Activity ticker — fetch domain data once, then rotate every 2.5 s
    _activities = const GetGymActivitiesUseCase().call();
    _timer = Timer.periodic(const Duration(milliseconds: 2500), (_) {
      if (mounted) {
        setState(() {
          _tickerIndex = (_tickerIndex + 1) % _activities.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _arcCtrl.dispose();
    _blob1.dispose();
    _blob2.dispose();
    _chipCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Blob aura 1 ────────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _blob1,
            builder: (_, __) {
              final s = 0.9 + _blob1.value * 0.4;
              final alpha = 0.04 + _blob1.value * 0.07;
              return Transform.scale(
                scale: s,
                child: Container(
                  width: 256,
                  height: 256,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: alpha),
                  ),
                ),
              );
            },
          ),

          // ── Blob aura 2 (larger, slower, phase-offset) ─────────────────────
          AnimatedBuilder(
            animation: _blob2,
            builder: (_, __) {
              final s = 1.0 + _blob2.value * 0.3;
              final alpha = 0.03 + _blob2.value * 0.05;
              return Transform.scale(
                scale: s,
                child: Container(
                  width: 288,
                  height: 288,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: alpha),
                  ),
                ),
              );
            },
          ),

          // ── Gauge disc + arc ────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _arcCtrl,
            builder: (_, __) {
              return CustomPaint(
                size: const Size(256, 256),
                painter: _GaugePainter(
                  progress: _arcProgress.value.clamp(0.0, 1.0),
                ),
                child: SizedBox(
                  width: 256,
                  height: 256,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${_counter.value}',
                              style: AppTextStyles.gaugeNumber,
                            ),
                            TextSpan(
                              text: '%',
                              style: AppTextStyles.gaugeUnit,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('FULL', style: AppTextStyles.gaugeLabel),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Activity ticker chip (slot-machine scroll) ─────────────────────
          //
          // AnimatedSwitcher handles transitions declaratively:
          //   • incoming child : animation 0→1 → slide from BELOW → center
          //   • outgoing child : animation 1→0 → slide center → ABOVE
          //
          // We distinguish in vs out via ValueKey(_tickerIndex):
          //   - child whose key == current index  → INCOMING (slide up from below)
          //   - child whose key != current index  → OUTGOING (slide up to top)
          Positioned(
            bottom: 44,
            child: AnimatedBuilder(
              animation: _chipCtrl,
              builder: (_, child) => Transform.scale(
                scale: _chipScale.value,
                child: child,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // ── Slot-machine ticker ─────────────────────────────────
                    ClipRect(
                      child: SizedBox(
                        width: 148,
                        height: 18,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 380),
                          layoutBuilder: (current, previous) => Stack(
                            alignment: Alignment.center,
                            children: [
                              ...previous,
                              if (current != null) current,
                            ],
                          ),
                          transitionBuilder: (child, animation) {
                            // child.key tells us if this is the incoming item
                            final isIncoming =
                                (child.key as ValueKey<int>).value ==
                                    _tickerIndex;

                            // Incoming : animation 0→1, enter from bottom
                            // Outgoing : animation 1→0, exit to top
                            final slideOffset = Tween<Offset>(
                              begin: isIncoming
                                  ? const Offset(0, 1) // enter from below
                                  : const Offset(0, -1), // exit to top
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: isIncoming
                                    ? Curves.easeOut
                                    : Curves.easeIn,
                              ),
                            );

                            return SlideTransition(
                              position: slideOffset,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: _buildActivityRow(_tickerIndex),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single activity row with a [ValueKey] so [AnimatedSwitcher]
  /// can distinguish entering vs leaving children.
  ///
  /// Icon resolution lives here (presentation layer) — the domain [GymActivity]
  /// entity only carries the [GymActivityType] enum.
  Widget _buildActivityRow(int index) {
    final a = _activities[index];
    return Row(
      key: ValueKey<int>(index),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(_iconFor(a.type), size: 15, color: AppColors.primaryContainer),
        const SizedBox(width: 5),
        Text(
          '${a.label} in ${a.duration}',
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.onSurface,
            fontSize: 13,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  /// Maps a [GymActivityType] to its [IconData].
  /// This mapping belongs in the presentation layer, not the domain.
  static IconData _iconFor(GymActivityType type) {
    switch (type) {
      case GymActivityType.skipping:
        return Icons.directions_run_rounded;
      case GymActivityType.cycling:
        return Icons.directions_bike_rounded;
      case GymActivityType.boxing:
        return Icons.sports_mma_rounded;
      case GymActivityType.yoga:
        return Icons.self_improvement_rounded;
      case GymActivityType.zumba:
        return Icons.music_note_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CustomPainter: gauge arc
// ─────────────────────────────────────────────────────────────────────────────

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.progress});

  /// 0.0 → 1.0 (0 % → 100 %). Clamped to 1.0 max.
  final double progress;

  // Full arc: 240° sweep starting from 150° (bottom-left → bottom-right)
  static const _startAngle = 150.0 * math.pi / 180.0;
  static const _fullSweep = 240.0 * math.pi / 180.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const strokeWidth = 12.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background disc
    canvas.drawCircle(
      center,
      size.width / 2,
      Paint()..color = AppColors.surfaceContainer,
    );

    // Track arc (grey)
    canvas.drawArc(
      rect,
      _startAngle,
      _fullSweep,
      false,
      Paint()
        ..color = AppColors.surfaceVariant
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    if (progress > 0) {
      final sweep = _fullSweep * progress.clamp(0.0, 1.0);

      // Glow layer
      canvas.drawArc(
        rect,
        _startAngle,
        sweep,
        false,
        Paint()
          ..color = AppColors.primaryContainer.withValues(alpha: 0.35)
          ..strokeWidth = strokeWidth + 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );

      // Main coloured arc
      canvas.drawArc(
        rect,
        _startAngle,
        sweep,
        false,
        Paint()
          ..shader = SweepGradient(
            startAngle: _startAngle,
            endAngle: _startAngle + _fullSweep,
            colors: const [AppColors.primaryContainer, AppColors.primary],
            stops: const [0.0, 1.0],
          ).createShader(rect)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.progress != progress;
}

