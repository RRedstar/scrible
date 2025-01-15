import 'package:flutter/material.dart';
import 'package:scrible/db_services.dart';
import 'package:scrible/painter.dart';
import 'package:scrible/stream_page.dart';

import 'classes.dart';

class PaintPage extends StatefulWidget {
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  late int _color = 0;
  late double _width = 5.0;
  late int _pathId = 0;
  late List<Point> _points;
  late List _pathList = [];
  final DatabaseService _dbService = DatabaseService();
  final List<Color> _colors = [
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

  @override
  void initState() {
    _dbService.clearPath();
    super.initState();
  }

  _startDraw(double x, double y) async {
    _points = [Point(x, y)];
    _pathId++;
    PathModel path = PathModel(
      color: _color,
      width: _width,
      points: _points,
    );
    setState(() {
      _pathList.add(path);
    });
  }

  _updateDraw(double x, double y) async {
    setState(() {
      _pathList.last.points.add(Point(x, y));
    });
  }

  _uploadData() async {
    PathModel path = PathModel(
      color: _color,
      width: _width,
      points: _points,
    );
    _dbService.addPath("$_pathId", path);
  }

  _updateData(double x, double y) async {
    _points.add(Point(x, y));

    PathModel path = PathModel(
      id: "$_pathId",
      color: _color,
      width: _width,
      points: _points,
    );
    _dbService.updatePath("$_pathId", path);
  }

  _clearPath() async {
    _dbService.clearPath();
    setState(() {
      _pathList = [];
    });
  }

  _undo() async {
    if (_pathList.isEmpty) return;
    _pathId--;
    _dbService.deletePath('$_pathId');

    setState(() {
      _pathList.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_forever_sharp),
              onPressed: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => StreamPage()));
                _clearPath();
              },
            )
          ],
          title: const Text('Paint Page'),
        ),
        body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          GestureDetector(
            onPanDown: (details) {
              // _uploadData(details.localPosition.dx, details.localPosition.dy);
              _startDraw(details.localPosition.dx, details.localPosition.dy);
            },
            onPanUpdate: (details) {
              // _updateData(details.localPosition.dx, details.localPosition.dy);
              _updateDraw(details.localPosition.dx, details.localPosition.dy);
            },
            onPanEnd: (details) => _uploadData(),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 260,
                color: Colors.white,
                child: CustomPaint(
                  painter: DrawPainter(_pathList),
                )),
          ),
          Container(
              color: Colors.blue,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 35),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    DrawingToolbar(),
                    Container(
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white10,
                      ),
                    )
                  ])))
        ])));
  }

  Row DrawingToolbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: () {
            _undo();
          },
          iconSize: 24,
        ),
        IconButton(
          icon: const Icon(Icons.delete_forever),
          onPressed: () {
            _clearPath();
          },
          iconSize: 24,
        ),
        IconButton(
          icon: const Icon(Icons.cleaning_services),
          onPressed: () {
            _color = 0;
            _width = 25;
          },
          iconSize: 24,
        ),
        DropdownButton(
          dropdownColor: Colors.transparent,
          icon: Icon(color: _colors[_color % 8], Icons.color_lens),
          iconSize: 24,
          onChanged: (value) {
            setState(() {
              _color = value as int;
            });
          },
          items: List.generate(
              8,
              (index) => DropdownMenuItem(
                    value: index,
                    child: Icon(size: 30, color: _colors[index], Icons.circle),
                  )),
        ),
        DropdownButton(
          menuWidth: 50,
          dropdownColor: Colors.transparent,
          icon: const Icon(Icons.circle),
          onChanged: (value) {
            setState(() {
              _color = _color == 8 ? 0 : _color;
              _width = value!.toDouble();
            });
          },

          items: List.generate(
              5,
              (index) => DropdownMenuItem(
                    value: (index + 1) * 5,
                    child: Icon(size: (index + 1) * 5, Icons.circle),
                  )),
          iconSize: 24,
        ),
      ],
    );
  }
}
