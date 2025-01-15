
class Point {
  double x;
  double y;
  Point(this.x, this.y);
}

class PathModel{
  final String? id;
  final double width;
  final int color;
  final List<Point> points;

  const PathModel({
    this.id,
    required this.width,
    required this.color,
    required this.points,
  });

  Map<String, Object?> toJson(){
    return {
      'width': width,
      'color': color,
      'points': points.map(
          (p) => '${p.x};${p.y}'
      ).toList(),
    };
  }

  PathModel.fromJson( Map<String, Object?> json) : this(
      id: json['id'] as String?,
      width: (json['width'] as num).toDouble(),
      color: json['color'] as int,
      points: (json['points'] as List).map(
          (p) => Point(
            double.parse(p.split(';')[0]),
            double.parse(p.split(';')[1]))
      ).toList(),
  );
}
