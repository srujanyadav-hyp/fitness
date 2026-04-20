import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Three concentric pulsing rings behind the logo — replicates the CSS
/// `animate-pulse-ring-{1,2,3}` keyframes with staggered delays.
class PulseRings extends StatefulWidget {
  const PulseRings({super.key});

  @override
  State<PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<PulseRings> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;
  late final List<Animation<double>> _opacities;

  static const _delays = [
    Duration.zero,
    Duration(milliseconds: 1000),
    Duration(milliseconds: 2000),
  ];
  static const _maxOpacities = [0.50, 0.38, 0.25];
  static const _ringSize = 300.0;
  static const _insets = [0.0, 16.0, 32.0];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 3000),
      );
      if (_delays[i] == Duration.zero) {
        // Start the first ring immediately so it's visible on the first frame.
        ctrl.repeat();
      } else {
        Future.delayed(_delays[i], () {
          if (mounted) ctrl.repeat();
        });
      }
      return ctrl;
    });

    _scales = _controllers
        .map(
          (c) => Tween<double>(begin: 0.8, end: 1.5).animate(
            CurvedAnimation(parent: c, curve: Curves.easeInOut),
          ),
        )
        .toList();

    _opacities = List.generate(3, (i) {
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0, end: _maxOpacities[i]),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: _maxOpacities[i], end: 0),
          weight: 50,
        ),
      ]).animate(_controllers[i]);
    });
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
    return SizedBox(
      width: _ringSize,
      height: _ringSize,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(3, (i) {
          final size = _ringSize - _insets[i] * 2;
          return AnimatedBuilder(
            animation: _controllers[i],
            builder: (_, __) => Transform.scale(
              scale: _scales[i].value,
              child: Opacity(
                opacity: _opacities[i].value,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
