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
  late final String id;
  final String roomName;
  final String language;
  final int nbMaxPlayer;
  final int nbRound;
  final int time;
  late final bool started;
  final List players;

  RoomModel(
      {required this.id,
      required this.roomName,
      required this.language,
      required this.nbMaxPlayer,
      required this.nbRound,
      required this.time,
      required  this.started,
      required  this.players,});

  @override
  Map<String, Object?> toJson() {
    return {
      "id": id,
      "language": language,
      "nbMaxPlayer": nbMaxPlayer,
      "nbRound": nbRound,
      "roomName": roomName,
      "time": time,
      "started": started,
      "players": players,
    };
  }

  RoomModel.fromJson(Map<String, Object?> json)
      : this(
          id: json['id'] as String,
          roomName: json['roomName'] as String,
          language: json['language'] as String,
          nbMaxPlayer: json['nbMaxPlayer'] as int,
          nbRound: json['nbRound'] as int,
          time: json['time'] as int,
          started: json['started'] as bool,
          players: json['players'] as List,
        );
}

class PlayerModel extends JsonConvertible {
  late final String id;
  final String name;
  String roomId;
  final int score;

  PlayerModel(
      {
        required this.id,
        required this.name,
        required this.roomId,
        required this.score,
      });

  @override
  Map<String, Object?> toJson() {
    return {
      "id": id,
      "name": name,
      "roomId": roomId,
      "score": score,
    };
  }

  PlayerModel.fromJson(Map<String, Object?> json)
      : this(
    id: json['id'] as String,
    name: json['name'] as String,
    roomId: json['roomId'] as String,
    score: json['score'] as int,
  );
}
