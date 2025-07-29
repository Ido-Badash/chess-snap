import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final Animation<double> floatingAnimation;

  const HeaderSection({super.key, required this.floatingAnimation});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App logo/icon with floating animation
        AnimatedBuilder(
          animation: floatingAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, floatingAnimation.value),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        // Title with gradient text effect
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFE8EAF6)],
          ).createShader(bounds),
          child: const Text(
            'ChessSnap',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Capture • Analyze • Play',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}
