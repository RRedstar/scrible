import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrible/painter.dart';
import 'package:scrible/stream_page.dart';

class PaintPage extends StatefulWidget{
  @override
  _PaintPageState createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage>{
  late Color _color;
  late double _width;
  late List<List<Coord>> _pathList;
  final db = FirebaseFirestore.instance;

  _startDraw(double x, double y) async {
    setState(() {
      _pathList.add([Coord(x, y)]);
    });
    var coord = <String, dynamic>{
      'x': x,
      'y': y
    };
    await db.collection('path').add(coord).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  _updateDraw(double x, double y) async {
    setState(() {
      if (_pathList.last!= null) {
        _pathList.last.add(Coord(x, y));
      }
    });
    var coord = <String, dynamic>{
      'x': x,
      'y': y
    };
    await db.collection('path').add(coord).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));
  }
  
  @override
  void initState() {
    // Default paint parametres
    _color = Colors.blue;
    _width = 5;
    _pathList = [
      []
    ];

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu)),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StreamPage()));
            },
          )
        ],
        title: const Text('Paint Page'),
      ),
      body: Center(
        child: GestureDetector(
          onPanDown: (details) => _startDraw(details.localPosition.dx, details.localPosition.dy),
          onPanUpdate: (details) => _updateDraw(details.localPosition.dx, details.localPosition.dy),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            color: Colors.white,
            child: CustomPaint(
              painter: DrawPainter(
                linecolor: _color,
                width: _width,
                pathList: _pathList,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
