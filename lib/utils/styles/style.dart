import 'package:flutter/material.dart';

const mainColor = Color(0xFF3C654D);
const secondaryColor = Color(0xff888888);

TextStyle subTextStyle({Color? color, double? size, FontWeight? weight}) {
  return TextStyle(
      fontSize: size ?? 15,
      color: color ?? const Color(0xFF3C654D),
      fontWeight: weight ?? FontWeight.bold);
}

class CircleIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final Color color;
  final double radius;

  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final double centerX = offset.dx + configuration.size!.width / 2;
    final double centerY = offset.dy + configuration.size!.height - radius + 14;
    final Offset circleOffset = Offset(centerX, centerY);
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
