import 'package:cloud_firestore/cloud_firestore.dart';

class Point {
  double x;
  double y;
  Point(this.x, this.y);
}

abstract class JsonConvertible {
  Map<String, dynamic> toJson();
}

class PathModel extends JsonConvertible {
  final String? id;
  final double width;
  final int color;
  final List<Point> points;

  PathModel({
    this.id,
    required this.width,
    required this.color,
    required this.points,
  });

  @override
  Map<String, Object?> toJson() {
    return {
      'width': width,
      'color': color,
      'points': points.map((p) => '${p.x};${p.y}').toList(),
    };
  }

  PathModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String?,
          width: (json['width'] as num).toDouble(),
          color: json['color'] as int,
          points: (json['points'] as List)
              .map((p) => Point(
                  double.parse(p.split(';')[0]), double.parse(p.split(';')[1])))
              .toList(),
        );
}

class RoomModel extends JsonConvertible {
  late final String? id;
  final String roomName;
  final String language;
  final int nbMaxUser;
  final int nbRound;
  final int nbUser;
  final int time;

  RoomModel(
      {this.id,
      required this.roomName,
      required this.language,
      required this.nbMaxUser,
      required this.nbRound,
      required this.nbUser,
      required this.time});

  @override
  Map<String, Object?> toJson() {
    return {
      "id": id,
      "language": language,
      "nbMaxUser": nbMaxUser,
      "nbRound": nbRound,
      "nbUser": nbUser,
      "roomName": roomName,
      "time": time,
    };
  }

  RoomModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String?,
          roomName: json['roomName'] as String,
          language: json['language'] as String,
          nbMaxUser: json['nbMaxUser'] as int,
          nbRound: json['nbRound'] as int,
          nbUser: json['nbUser'] as int,
          time: json['time'] as int,
        );
}
