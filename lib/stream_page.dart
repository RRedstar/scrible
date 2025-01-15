import 'package:flutter/material.dart';
import 'package:scrible/db_services.dart';
import 'package:scrible/painter.dart';
import 'package:scrible/stream_page.dart';

import 'classes.dart';

class StreamPage extends StatefulWidget {
  @override
  _StreamPageState createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  final DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye_outlined),
              onPressed: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => StreamPage()));
              },
            )
          ],
          title: const Text('Stream Page'),
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            color: Colors.white,
            child: StreamBuilder(
                stream: _dbService.getPath(),
                builder: (context, snapshot) {
                  List pathList = snapshot.data?.docs ?? [];

                  return CustomPaint(
                    painter: DrawPainter(pathList),
                  );
                  // CustomPaint(painter: DrawPainter(_pathList)),
                }),
          ),
        ));
  }
}
