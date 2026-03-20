import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/dragon_assets.dart';
import '../theme/dragon_colors.dart';

const _evolutionNames = [
  'Egg',
  'Hatchling',
  'Fledgling',
  'Young Dragon',
  'Adult Dragon',
  'Elder Dragon',
];

/// Shows a full-screen "Dragon's Roar" celebration when the dragon evolves.
Future<void> showEvolutionCelebration(
  BuildContext context, {
  required int oldStage,
  required int newStage,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (ctx, anim1, anim2) => _EvolutionCelebration(
      oldStage: oldStage,
      newStage: newStage,
    ),
  );
}

class _EvolutionCelebration extends StatefulWidget {
  final int oldStage;
  final int newStage;

  const _EvolutionCelebration({
    required this.oldStage,
    required this.newStage,
  });

  @override
  State<_EvolutionCelebration> createState() => _EvolutionCelebrationState();
}

class _EvolutionCelebrationState extends State<_EvolutionCelebration>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _shakeController;
  late AnimationController _dragonController;
  late AnimationController _ringController;
  late AnimationController _textController;
  late AnimationController _promptController;
  late AnimationController _shimmerController;

  late Animation<double> _overlayOpacity;
  late Animation<double> _flashOpacity;
  late Animation<double> _dragonScale;
  late Animation<double> _ringExpand;
  late Animation<double> _ringOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _promptOpacity;

  bool _canDismiss = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _runSequence();
  }

  void _setupAnimations() {
    // Background darken + fire flash (500ms)
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _overlayOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeIn),
    );
    _flashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.6), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.0), weight: 70),
    ]).animate(_overlayController);

    // Screen shake (600ms)
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Dragon portrait bounce-in (700ms, easeOutBack)
    _dragonController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _dragonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dragonController, curve: Curves.easeOutBack),
    );

    // Gold ring expand (1000ms)
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _ringExpand = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOut),
    );
    _ringOpacity = Tween<double>(begin: 0.8, end: 0.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeIn),
    );

    // Stage name fade-in (500ms)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // "Tap to continue" fade-in (400ms)
    _promptController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _promptOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _promptController, curve: Curves.easeOut),
    );

    // Continuous shimmer loop for stage name
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  Future<void> _runSequence() async {
    // 0–500ms: darken + flash
    await _overlayController.forward();
    // 500–1100ms: shake + dragon bounce + ring expand
    _shakeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _dragonController.forward();
    _ringController.forward();
    // 1200–1700ms: text fade-in
    await Future.delayed(const Duration(milliseconds: 500));
    await _textController.forward();
    // 2300–2700ms: prompt
    await Future.delayed(const Duration(milliseconds: 600));
    await _promptController.forward();
    if (mounted) setState(() => _canDismiss = true);
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _shakeController.dispose();
    _dragonController.dispose();
    _ringController.dispose();
    _textController.dispose();
    _promptController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.newStage.clamp(0, 5);
    final stageName = _evolutionNames[stage];
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _canDismiss ? () => Navigator.of(context).pop() : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _overlayController,
          _shakeController,
          _dragonController,
          _ringController,
          _textController,
          _promptController,
          _shimmerController,
        ]),
        builder: (context, child) {
          // Screen shake: rapid decaying oscillation
          final sp = _shakeController.value;
          final intensity = 6.0 * (1.0 - sp);
          final shakeX = intensity * sin(sp * 12 * pi);
          final shakeY = intensity * cos(sp * 8 * pi) * 0.5;

          return Transform.translate(
            offset: Offset(shakeX, shakeY),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Dark overlay
                  Opacity(
                    opacity: _overlayOpacity.value * 0.88,
                    child: const ColoredBox(color: Color(0xFF0D0D1A)),
                  ),

                  // Radial fire flash
                  Opacity(
                    opacity: _flashOpacity.value,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            DragonColors.dragonGold,
                            DragonColors.fireOrange,
                            Colors.transparent,
                          ],
                          stops: [0.0, 0.3, 0.7],
                        ),
                      ),
                    ),
                  ),

                  // Gold particle ring
                  Center(
                    child: CustomPaint(
                      size: Size(screenSize.width, screenSize.width),
                      painter: _GoldRingPainter(
                        expand: _ringExpand.value,
                        opacity: _ringOpacity.value,
                      ),
                    ),
                  ),

                  // Center content
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        FadeTransition(
                          opacity: _textOpacity,
                          child: Text(
                            widget.oldStage == 0
                                ? 'YOUR DRAGON HAS HATCHED!'
                                : 'YOUR DRAGON HAS GROWN!',
                            style: TextStyle(
                              fontFamily: 'Cinzel',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  DragonColors.dragonGold.withAlpha(200),
                              letterSpacing: 3.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Dragon portrait with glow + bounce
                        Transform.scale(
                          scale: _dragonScale.value,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: DragonColors.dragonGold.withAlpha(
                                    (80 * _dragonScale.value).round(),
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: DragonColors.fireOrange.withAlpha(
                                    (40 * _dragonScale.value).round(),
                                  ),
                                  blurRadius: 60,
                                  spreadRadius: 16,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              DragonAssets.dragonHubCompanions[stage],
                              width: 140,
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Stage name with gold shimmer
                        FadeTransition(
                          opacity: _textOpacity,
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              final offset =
                                  _shimmerController.value * 3.0 - 1.0;
                              return LinearGradient(
                                begin: Alignment(offset - 0.3, 0),
                                end: Alignment(offset + 0.3, 0),
                                colors: const [
                                  DragonColors.dragonGold,
                                  DragonColors.warmGlow,
                                  Color(0xFFFFF8E1),
                                  DragonColors.warmGlow,
                                  DragonColors.dragonGold,
                                ],
                                stops: const [
                                  0.0, 0.35, 0.5, 0.65, 1.0
                                ],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              stageName,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Tap to dismiss
                        FadeTransition(
                          opacity: _promptOpacity,
                          child: Text(
                            'Tap to continue',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: DragonColors.textSecondary
                                  .withAlpha(180),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoldRingPainter extends CustomPainter {
  final double expand;
  final double opacity;

  _GoldRingPainter({required this.expand, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.6;
    final radius = maxRadius * expand;

    // Ring stroke
    final paint = Paint()
      ..color = DragonColors.dragonGold.withAlpha((opacity * 255).round())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * (1.0 - expand) + 0.5;
    canvas.drawCircle(center, radius, paint);

    // Particle dots around the ring
    const particleCount = 12;
    final particlePaint = Paint()
      ..color = DragonColors.warmGlow.withAlpha((opacity * 200).round());

    for (int i = 0; i < particleCount; i++) {
      final angle =
          (i / particleCount) * 2 * pi + expand * pi * 0.5;
      final dotRadius = 2.5 * (1.0 - expand * 0.5);
      final px = center.dx + radius * cos(angle);
      final py = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(px, py), dotRadius, particlePaint);
    }
  }

  @override
  bool shouldRepaint(_GoldRingPainter old) =>
      old.expand != expand || old.opacity != opacity;
}
