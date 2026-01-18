import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptom_checker/core/constants/body_regions.dart';
import 'package:symptom_checker/presentation/bloc/symptom_bloc.dart';

class BodyMapWidget extends StatefulWidget {
  const BodyMapWidget({super.key});

  @override
  State<BodyMapWidget> createState() => _BodyMapWidgetState();
}

class _BodyMapWidgetState extends State<BodyMapWidget> {
  BodyRegion? _hoveredRegion;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: BodyMapPainter(
            hoveredRegion: _hoveredRegion,
            primaryColor: Theme.of(context).colorScheme.primary,
          ),
          child: GestureDetector(
            onTapUp: (details) {
              final region = _getRegionFromPosition(
                details.localPosition,
                context.size!,
              );
              if (region != null) {
                context.read<SymptomBloc>().add(SelectBodyRegion(region));
              }
            },
            onPanUpdate: (details) {
              final region = _getRegionFromPosition(
                details.localPosition,
                context.size!,
              );
              if (region != _hoveredRegion) {
                setState(() {
                  _hoveredRegion = region;
                });
              }
            },
            onPanEnd: (_) {
              setState(() {
                _hoveredRegion = null;
              });
            },
          ),
        ),
      ),
    );
  }

  BodyRegion? _getRegionFromPosition(Offset position, Size size) {
    final x = position.dx / size.width;
    final y = position.dy / size.height;

    // Head regions (top 20%)
    if (y < 0.2) {
      if (x < 0.35) return BodyRegion.headLeft;
      if (x > 0.65) return BodyRegion.headRight;
      if (y < 0.1) return BodyRegion.headBack;
      return BodyRegion.headFront;
    }

    // Chest region (20-40%)
    if (y >= 0.2 && y < 0.4) {
      return BodyRegion.chest;
    }

    // Abdomen regions (40-70%)
    if (y >= 0.4 && y < 0.7) {
      if (y < 0.55) {
        // Upper abdomen
        return x < 0.5 ? BodyRegion.abdomenUpperLeft : BodyRegion.abdomenUpperRight;
      } else {
        // Lower abdomen
        return x < 0.5 ? BodyRegion.abdomenLowerLeft : BodyRegion.abdomenLowerRight;
      }
    }

    return null;
  }
}

class BodyMapPainter extends CustomPainter {
  final BodyRegion? hoveredRegion;
  final Color primaryColor;

  BodyMapPainter({
    this.hoveredRegion,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey[300]!;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey[600]!
      ..strokeWidth = 2;

    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = primaryColor.withOpacity(0.3);

    // Draw body outline
    final bodyPath = Path();
    
    // Head (circle)
    final headCenter = Offset(size.width / 2, size.height * 0.1);
    final headRadius = size.width * 0.15;
    bodyPath.addOval(Rect.fromCircle(center: headCenter, radius: headRadius));
    
    // Neck
    bodyPath.addRect(Rect.fromLTWH(
      size.width * 0.45,
      size.height * 0.17,
      size.width * 0.1,
      size.height * 0.05,
    ));
    
    // Torso
    final torsoPath = Path();
    torsoPath.moveTo(size.width * 0.3, size.height * 0.22);
    torsoPath.lineTo(size.width * 0.7, size.height * 0.22);
    torsoPath.lineTo(size.width * 0.65, size.height * 0.7);
    torsoPath.lineTo(size.width * 0.35, size.height * 0.7);
    torsoPath.close();
    
    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(torsoPath, paint);
    canvas.drawPath(bodyPath, strokePaint);
    canvas.drawPath(torsoPath, strokePaint);

    // Draw region highlights
    _drawRegionHighlight(canvas, size, BodyRegion.headFront, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.headLeft, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.headRight, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.chest, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.abdomenUpperLeft, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.abdomenUpperRight, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.abdomenLowerLeft, highlightPaint, strokePaint);
    _drawRegionHighlight(canvas, size, BodyRegion.abdomenLowerRight, highlightPaint, strokePaint);

    // Draw labels
    _drawLabel(canvas, size, 'Head', Offset(size.width / 2, size.height * 0.1));
    _drawLabel(canvas, size, 'Chest', Offset(size.width / 2, size.height * 0.3));
    _drawLabel(canvas, size, 'Abdomen', Offset(size.width / 2, size.height * 0.55));
  }

  void _drawRegionHighlight(
    Canvas canvas,
    Size size,
    BodyRegion region,
    Paint highlightPaint,
    Paint strokePaint,
  ) {
    if (hoveredRegion != region) return;

    final path = _getRegionPath(size, region);
    canvas.drawPath(path, highlightPaint);
    canvas.drawPath(path, strokePaint);
  }

  Path _getRegionPath(Size size, BodyRegion region) {
    final path = Path();

    switch (region) {
      case BodyRegion.headFront:
        final center = Offset(size.width / 2, size.height * 0.12);
        path.addOval(Rect.fromCircle(center: center, radius: size.width * 0.12));
        break;
      case BodyRegion.headLeft:
        final center = Offset(size.width * 0.35, size.height * 0.1);
        path.addOval(Rect.fromCircle(center: center, radius: size.width * 0.08));
        break;
      case BodyRegion.headRight:
        final center = Offset(size.width * 0.65, size.height * 0.1);
        path.addOval(Rect.fromCircle(center: center, radius: size.width * 0.08));
        break;
      case BodyRegion.chest:
        path.addRect(Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.22,
          size.width * 0.3,
          size.height * 0.18,
        ));
        break;
      case BodyRegion.abdomenUpperLeft:
        path.addRect(Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.4,
          size.width * 0.15,
          size.height * 0.15,
        ));
        break;
      case BodyRegion.abdomenUpperRight:
        path.addRect(Rect.fromLTWH(
          size.width * 0.5,
          size.height * 0.4,
          size.width * 0.15,
          size.height * 0.15,
        ));
        break;
      case BodyRegion.abdomenLowerLeft:
        path.addRect(Rect.fromLTWH(
          size.width * 0.35,
          size.height * 0.55,
          size.width * 0.15,
          size.height * 0.15,
        ));
        break;
      case BodyRegion.abdomenLowerRight:
        path.addRect(Rect.fromLTWH(
          size.width * 0.5,
          size.height * 0.55,
          size.width * 0.15,
          size.height * 0.15,
        ));
        break;
      default:
        break;
    }

    return path;
  }

  void _drawLabel(Canvas canvas, Size size, String text, Offset position) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(BodyMapPainter oldDelegate) {
    return oldDelegate.hoveredRegion != hoveredRegion;
  }
}