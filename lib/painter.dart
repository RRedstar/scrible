import 'package:flutter/material.dart';
import 'classes.dart';

class DrawPainter extends CustomPainter {
  final List<Color> colors = [
    Colors.black,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.white
  ];

  List pathList;

  DrawPainter(this.pathList);

  @override
  void paint(Canvas canvas, Size size) {
    if (pathList.isNotEmpty){
      // Draw paths
      for (var instance in pathList) {
        var path = instance is PathModel ? instance : instance.data();

        // Set paint parameters
        Paint paint = Paint()
          ..color = colors[path.color]
          ..style = PaintingStyle.stroke
          ..strokeWidth = path.width;

        // Create a new path and add the points from the current path to it
        Path pathToDraw = Path();
        List<Point> points = path.points;

        if (points.isEmpty){
          continue; // Skip this path if it has no points
        }

        // Move to the first point and draw a line to each subsequent point until the last point is reached
        Point start = points.first;
        pathToDraw.moveTo(start.x, start.y);

        for (int i = 1; i < points.length; i++) {
          // Get the current and next points
          Point point = points[i];
          pathToDraw.lineTo(point.x, point.y);
        }

        // Draw the path on the canvas
        canvas.drawPath(pathToDraw, paint);
      }

    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
