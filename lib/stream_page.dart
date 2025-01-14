import 'package:flutter/material.dart';
import 'package:scrible/painter.dart';

class StreamPage extends StatefulWidget{
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage>{
  late Color _color;
  late double _width;
  late List<List<Coord>> _pathList;

  _startDraw(double x, double y){
    setState(() {
      _pathList.add([Coord(x, y)]);
    });
  }

  _updateDraw(double x, double y){
    setState(() {
      if (_pathList.last!= null) {
        _pathList.last.add(Coord(x, y));
      }
    });
  }
  
  @override
  void initState() {
    // Default paint parametres
    _color = Colors.red;
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
        leading: IconButton(onPressed: () {

        }, icon: const Icon(Icons.menu)),
        title: const Text('Stream Page'),
      ),
      body: Center(
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
    );
  }
}
