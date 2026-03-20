import 'package:flutter/material.dart';

class CountdownOverlay extends StatefulWidget {
  final VoidCallback onComplete;

  const CountdownOverlay({super.key, required this.onComplete});

  @override
  State<CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<CountdownOverlay>
    with SingleTickerProviderStateMixin {
  int _count = 3;
  bool _showGo = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.6, end: 0.9).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.0, 0.4)),
    );
    _startCountdown();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startCountdown() async {
    for (int i = 3; i > 0; i--) {
      if (!mounted) return;
      setState(() {
        _count = i;
        _showGo = false;
      });
      _animController.forward(from: 0);
      await Future.delayed(const Duration(milliseconds: 800));
    }
    if (!mounted) return;
    setState(() => _showGo = true);
    _animController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Text(
                  _showGo ? 'GO!' : '$_count',
                  style: TextStyle(
                    fontFamily: 'Cinzel',
                    fontSize: _showGo ? 84 : 72,
                    fontWeight: FontWeight.bold,
                    color: _showGo
                        ? const Color(0xFFF4A261)
                        : Colors.white,
                    shadows: [
                      Shadow(
                        color: (_showGo
                                ? const Color(0xFFF4A261)
                                : const Color(0xFFE74C3C))
                            .withValues(alpha: 0.6),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
