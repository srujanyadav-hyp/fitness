import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// 12 tiny spark dots that float upward continuously — replicates the CSS
/// `.spark` + `animate-float-up-{1..4}` keyframes in the reference HTML.
///
/// Uses [MediaQuery] for dimensions instead of [LayoutBuilder] so it works
/// safely as a direct child of an unbounded [Stack].
class SparkParticles extends StatefulWidget {
  const SparkParticles({super.key});

  @override
  State<SparkParticles> createState() => _SparkParticlesState();
}

class _SparkParticlesState extends State<SparkParticles>
    with TickerProviderStateMixin {
  static const _particles = <_Particle>[
    _Particle(left: 0.10, size: 2, duration: 4000, delay: 0),
    _Particle(left: 0.25, size: 3, duration: 5000, delay: 200),
    _Particle(left: 0.35, size: 1, duration: 3500, delay: 1500),
    _Particle(left: 0.45, size: 2, duration: 6000, delay: 800),
    _Particle(left: 0.60, size: 3, duration: 4000, delay: 2100),
    _Particle(left: 0.75, size: 2, duration: 5000, delay: 500),
    _Particle(left: 0.85, size: 1, duration: 3500, delay: 1800),
    _Particle(left: 0.90, size: 2, duration: 6000, delay: 300),
    _Particle(left: 0.15, size: 3, duration: 5000, delay: 2500),
    _Particle(left: 0.55, size: 1, duration: 4000, delay: 1100),
    _Particle(left: 0.80, size: 2, duration: 6000, delay: 2900),
    _Particle(left: 0.30, size: 1, duration: 3500, delay: 700),
  ];

  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _positions;
  late final List<Animation<double>> _opacities;

  @override
  void initState() {
    super.initState();

    _controllers = _particles.map((p) {
      final ctrl = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: p.duration),
      );
      // Start immediately for delay=0, otherwise schedule
      if (p.delay == 0) {
        ctrl.repeat();
      } else {
        Future.delayed(Duration(milliseconds: p.delay), () {
          if (mounted) ctrl.repeat();
        });
      }
      return ctrl;
    }).toList();

    _positions = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(c))
        .toList();

    _opacities = _controllers.map((c) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.45), weight: 20),
        TweenSequenceItem(tween: ConstantTween(0.45), weight: 60),
        TweenSequenceItem(tween: Tween(begin: 0.45, end: 0.0), weight: 20),
      ]).animate(c);
    }).toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery — safe inside any ancestor including an unbounded Stack.
    final size = MediaQuery.sizeOf(context);
    final zoneHeight = size.height * 0.5;

    return SizedBox(
      width: size.width,
      height: zoneHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: List.generate(_particles.length, (i) {
          final p = _particles[i];
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) {
              // progress 0 → bottom of zone, 1 → top of zone
              final y = zoneHeight * (1.0 - _positions[i].value);
              return Positioned(
                left: size.width * p.left,
                top: y,
                child: Opacity(
                  opacity: _opacities[i].value,
                  child: SizedBox(
                    width: p.size.toDouble(),
                    height: p.size.toDouble(),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.left,
    required this.size,
    required this.duration,
    required this.delay,
  });

  final double left;
  final int size;
  final int duration;
  final int delay;
}
