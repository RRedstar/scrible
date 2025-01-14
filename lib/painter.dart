import 'package:flutter/material.dart';

class DrawPainter extends CustomPainter {
  Color linecolor;
  double width;
  List<List<Coord>> pathList;

  DrawPainter({required this.linecolor, required this.width, required this.pathList});

  @override
  void paint(Canvas canvas, Size size) {
    // Parametrer paint
    Paint paint = Paint()
      ..color = linecolor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    // Draw paths
    for (var path in pathList) {
      Path pathToDraw = Path();
      if (path.isNotEmpty) {
        Coord start = path.first;
        pathToDraw.moveTo(start.x, start.y);

        for (var i = 1; i < path.length; i++) {
          Coord point = path[i];
          pathToDraw.lineTo(point.x, point.y);
          // pathToDraw.moveTo(point.x, point.y);
        }
      }
      canvas.drawPath(pathToDraw, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Coord {
  double x;
  double y;
  Coord(this.x, this.y);
}