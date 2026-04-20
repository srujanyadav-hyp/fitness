import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

/// Screen 1 — **"Radar City"** illustration.
///
/// A premium radar sweeps 360° across a city network map.
/// As the beam passes each hidden gym, it reveals a glowing pin + info badge.
///
/// Animations:
/// - Radar sweep    : 360° CW, 4 s per rotation, linear
/// - Radar trail    : 90° orange gradient wedge behind the beam
/// - Gym reveal     : scale-in + fade triggered as radar hits each pin
/// - Info badges    : slide up + fade 250 ms after the pin appears
/// - Badge float    : gentle phase-offset vertical drift (continuous)
/// - User pulse     : teal ring expands and fades, 1.6 s loop
class MapIllustration extends StatefulWidget {
  const MapIllustration({super.key});

  @override
  State<MapIllustration> createState() => _MapIllustrationState();
}

class _MapIllustrationState extends State<MapIllustration>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  late final AnimationController _sweepCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _floatCtrl;
  late final List<AnimationController> _gymCtrl;
  late final List<Animation<double>> _gymAnim;

  final _revealed = [false, false, false];
  double _prevSweep = 0;

  // ── Gym data ───────────────────────────────────────────────────────────────
  static const _gyms = [
    _GymData(
      alignment: Alignment(-0.52, -0.42),
      name: 'PowerFit Gym',
      distance: '0.3 km',
      revealAt: 0.13, // fraction of full 360° rotation
    ),
    _GymData(
      alignment: Alignment(0.56, 0.08),
      name: 'Zen Studio',
      distance: '0.7 km',
      revealAt: 0.47,
    ),
    _GymData(
      alignment: Alignment(-0.08, 0.65),
      name: 'Iron Arena',
      distance: '1.1 km',
      revealAt: 0.72,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _sweepCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    _gymCtrl = List.generate(
      _gyms.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 550),
      ),
    );

    _gymAnim = _gymCtrl.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.easeOutBack);
    }).toList();

    _sweepCtrl.addListener(_onSweepTick);
  }

  void _onSweepTick() {
    final v = _sweepCtrl.value;
    // Detect wrap-around → dim gyms for next sweep cycle
    if (v < _prevSweep - 0.1) {
      for (int i = 0; i < _gyms.length; i++) {
        _revealed[i] = false;
        _gymCtrl[i].reverse();
      }
    }
    // Reveal gyms as radar beam sweeps past them
    for (int i = 0; i < _gyms.length; i++) {
      if (!_revealed[i] && v >= _gyms[i].revealAt) {
        _revealed[i] = true;
        _gymCtrl[i].forward(from: 0);
      }
    }
    _prevSweep = v;
  }

  @override
  void dispose() {
    _sweepCtrl.removeListener(_onSweepTick);
    _sweepCtrl.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    for (final c in _gymCtrl) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          // ── Radar canvas (fills the full Stack) ──────────────────────────
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _sweepCtrl,
              builder: (_, __) => CustomPaint(
                painter: _RadarPainter(sweepProgress: _sweepCtrl.value),
              ),
            ),
          ),

          // ── Gym pins + badges ─────────────────────────────────────────────
          ...List.generate(_gyms.length, (i) {
            return AnimatedBuilder(
              animation: Listenable.merge([_gymCtrl[i], _floatCtrl]),
              builder: (_, __) {
                final floatY =
                    _floatCtrl.value * 6.0 * (i.isEven ? 1.0 : -1.0);
                return Align(
                  alignment: _gyms[i].alignment,
                  child: Transform.translate(
                    offset: Offset(0, floatY),
                    child: _GymNodeWidget(
                      gym: _gyms[i],
                      progress: _gymAnim[i].value,
                    ),
                  ),
                );
              },
            );
          }),

          // ── User location dot (center) ────────────────────────────────────
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) => Center(
              child: _UserDot(pulse: _pulseCtrl.value),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

class _GymData {
  const _GymData({
    required this.alignment,
    required this.name,
    required this.distance,
    required this.revealAt,
  });

  final Alignment alignment;
  final String name;
  final String distance;

  /// Fraction of a full 360° rotation at which the radar beam reveals this gym.
  final double revealAt;
}

// ─────────────────────────────────────────────────────────────────────────────
// CustomPainter — radar backdrop
// ─────────────────────────────────────────────────────────────────────────────

class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.sweepProgress});

  final double sweepProgress; // 0.0 → 1.0 (fraction of 360°)

  // ── City network: normalised offsets (dx ∈ [0,1], dy ∈ [0,1]) ────────────
  static const _nodes = <Offset>[
    Offset(0.12, 0.20), Offset(0.30, 0.10), Offset(0.55, 0.06),
    Offset(0.78, 0.17), Offset(0.92, 0.36), Offset(0.89, 0.58),
    Offset(0.76, 0.78), Offset(0.55, 0.91), Offset(0.30, 0.86),
    Offset(0.10, 0.70), Offset(0.07, 0.45),
    Offset(0.24, 0.54), Offset(0.43, 0.34), Offset(0.66, 0.44),
    Offset(0.47, 0.63),
  ];

  static const _edges = <List<int>>[
    [0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6],
    [6, 7], [7, 8], [8, 9], [9, 10], [10, 0],
    [11, 12], [12, 13], [13, 14], [14, 11],
    [0, 11], [2, 12], [4, 13], [6, 14], [8, 11],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width * 0.44;
    // Angle convention: 0 = 3-o'clock, positive = clockwise (Flutter canvas)
    final currentAngle = -math.pi / 2 + sweepProgress * 2 * math.pi;

    _drawGrid(canvas, size);
    _drawRangeRings(canvas, center, outerR);
    _drawNetwork(canvas, size);
    _drawTrail(canvas, center, outerR, currentAngle);
    _drawBeam(canvas, center, outerR, currentAngle);
    _drawCrosshair(canvas, center);
  }

  // Subtle dot grid
  void _drawGrid(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.surfaceVariant.withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;
    const step = 22.0;
    for (double x = step / 2; x < size.width; x += step) {
      for (double y = step / 2; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.85, p);
      }
    }
  }

  // Three faint concentric range rings
  void _drawRangeRings(Canvas canvas, Offset center, double outerR) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;
    for (final frac in [0.33, 0.66, 1.0]) {
      p.color = AppColors.primaryContainer.withValues(
        alpha: frac == 1.0 ? 0.10 : 0.06,
      );
      canvas.drawCircle(center, outerR * frac, p);
    }
  }

  // City network: faint edges + tiny node dots
  void _drawNetwork(Canvas canvas, Size size) {
    final px = _nodes.map((n) => Offset(n.dx * size.width, n.dy * size.height)).toList();

    final edgePaint = Paint()
      ..color = AppColors.surfaceVariant.withValues(alpha: 0.28)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    for (final e in _edges) {
      canvas.drawLine(px[e[0]], px[e[1]], edgePaint);
    }

    final nodePaint = Paint()
      ..color = AppColors.surfaceVariant.withValues(alpha: 0.50)
      ..style = PaintingStyle.fill;
    for (final p in px) {
      canvas.drawCircle(p, 1.8, nodePaint);
    }
  }

  // Radar trail: a fan of 80 thin lines radiating from centre.
  //
  // Why not a filled wedge?  A SweepGradient wedge has a hard outer-arc edge
  // that becomes very visible at certain beam positions (the arc boundary is
  // always rendered as a crisp curve).  A fan of lines has NO arc path at all,
  // so there is no boundary artefact — the result looks identical from every
  // angle of the sweep.
  void _drawTrail(Canvas canvas, Offset center, double outerR, double angle) {
    const trailSweep = math.pi / 2; // 90° of trailing glow
    const numLines = 80; // density — enough to cover gaps at any radius

    for (int i = 0; i < numLines; i++) {
      // fraction 0 = trailing-end (transparent) → 1 = leading edge (brightest)
      final fraction = i / numLines;
      final lineAngle = angle - trailSweep + (fraction * trailSweep);
      final tip = Offset(
        center.dx + outerR * math.cos(lineAngle),
        center.dy + outerR * math.sin(lineAngle),
      );
      canvas.drawLine(
        center,
        tip,
        Paint()
          ..color =
              AppColors.primaryContainer.withValues(alpha: fraction * 0.13)
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  // Radar beam: single crisp gradient line (dim at centre → bright at tip).
  // Only ONE line is drawn — no glow layer, no V-shape artefact.
  void _drawBeam(Canvas canvas, Offset center, double outerR, double angle) {
    final tip = Offset(
      center.dx + outerR * math.cos(angle),
      center.dy + outerR * math.sin(angle),
    );

    // Gradient: translucent near center → solid at the tip edge.
    final shader = LinearGradient(
      colors: [
        AppColors.primaryContainer.withValues(alpha: 0.15),
        AppColors.primaryContainer.withValues(alpha: 0.92),
      ],
    ).createShader(Rect.fromPoints(center, tip));

    canvas.drawLine(
      center,
      tip,
      Paint()
        ..shader = shader
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
  }

  // Tiny teal crosshair at center
  void _drawCrosshair(Canvas canvas, Offset center) {
    const arm = 7.0;
    final p = Paint()
      ..color = AppColors.tertiary.withValues(alpha: 0.45)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx - arm, center.dy),
      Offset(center.dx + arm, center.dy),
      p,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - arm),
      Offset(center.dx, center.dy + arm),
      p,
    );
  }

  @override
  bool shouldRepaint(_RadarPainter old) =>
      old.sweepProgress != sweepProgress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Gym node widget: glowing pin + info badge
// ─────────────────────────────────────────────────────────────────────────────

class _GymNodeWidget extends StatelessWidget {
  const _GymNodeWidget({required this.gym, required this.progress});

  final _GymData gym;

  /// Value from [CurvedAnimation] — may slightly exceed 1.0 (easeOutBack).
  final double progress;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) return const SizedBox.shrink();

    final p = progress.clamp(0.0, 1.0); // for opacity/fade
    final s = progress; // for scale (can overshoot)

    // Badge fades in after the pin has mostly appeared (progress > 0.5)
    final badgeOpacity = ((p - 0.45) / 0.55).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Glow + core dot ─────────────────────────────────────────────────
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow aura
            Transform.scale(
              scale: s.clamp(0.0, 1.5),
              child: Opacity(
                opacity: p * 0.45,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryContainer.withValues(alpha: 0.30),
                  ),
                ),
              ),
            ),
            // Core dot
            Transform.scale(
              scale: s.clamp(0.0, 1.7),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.70),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // ── Info badge ───────────────────────────────────────────────────────
        Opacity(
          opacity: badgeOpacity,
          child: Transform.translate(
            offset: Offset(0, (1 - p) * 10),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primaryContainer.withValues(alpha: 0.22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.32),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gym.name,
                    style: AppTextStyles.labelMd.copyWith(
                      fontSize: 11,
                      letterSpacing: 0.1,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.place_rounded,
                        size: 9,
                        color: AppColors.primaryContainer,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        gym.distance,
                        style: AppTextStyles.bodyMd.copyWith(
                          fontSize: 9,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User location dot — teal + expanding pulse ring
// ─────────────────────────────────────────────────────────────────────────────

class _UserDot extends StatelessWidget {
  const _UserDot({required this.pulse});

  final double pulse; // 0.0 → 1.0

  @override
  Widget build(BuildContext context) {
    // Ring: scale 0.5 → 2.0, opacity 0.55 → 0
    final ringScale = 0.5 + pulse * 1.5;
    final ringOpacity = (1.0 - pulse) * 0.50;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulse ring
        Transform.scale(
          scale: ringScale,
          child: Opacity(
            opacity: ringOpacity,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.tertiary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        // Inner filled dot
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.tertiary,
            border: Border.all(color: AppColors.surface, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.tertiary.withValues(alpha: 0.80),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
