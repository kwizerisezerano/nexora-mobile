import 'package:flutter/material.dart';

import '../core/site.dart';
import '../theme/app_theme.dart';

/// Nexora "Green Orbit" logo. Uses the hosted brand asset and falls back to a
/// drawn mark when the image cannot be loaded (e.g. offline or in tests).
class NexoraLogo extends StatelessWidget {
  const NexoraLogo({super.key, this.height = 32, this.onWhiteChip = false});

  final double height;

  /// Wraps the logo on a white chip — required in dark mode because the brand
  /// logo is predominantly dark (mirrors the website navbar behaviour).
  final bool onWhiteChip;

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      Site.logoUrl,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _DrawnMark(height: height),
    );

    if (!onWhiteChip) return image;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: NxColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: NxColors.shadowSoft1, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: image,
    );
  }
}

class _DrawnMark extends StatelessWidget {
  const _DrawnMark({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: height,
            height: height,
            child: CustomPaint(painter: _OrbitPainter()),
          ),
          const SizedBox(width: 8),
          Text(
            'Nexora',
            style: TextStyle(
              fontSize: height * 0.62,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: NxColors.brand700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.30;
    canvas.drawCircle(center, radius, Paint()..color = NxColors.brand500);

    final orbit = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..color = NxColors.brand600;
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: size.width * 0.92,
        height: size.height * 0.42,
      ),
      orbit,
    );

    canvas.drawCircle(
      Offset(size.width * 0.88, size.height * 0.32),
      size.width * 0.09,
      Paint()..color = NxColors.brand400,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
