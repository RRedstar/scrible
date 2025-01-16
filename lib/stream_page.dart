import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrible/db_services.dart';
import 'package:scrible/painter.dart';

import 'classes.dart';

class StreamPage extends StatefulWidget {
  final String roomId;

  const StreamPage({required this.roomId});
  @override
  _StreamPageState createState() => _StreamPageState(roomId);
}

class _StreamPageState extends State<StreamPage> {
  final String _roomId;
  final DatabaseGeneralService _dbPath = DatabaseGeneralService<PathModel>(
      collectionName: "Path", fromJson: PathModel.fromJson);

  _StreamPageState(this._roomId);

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
            child: StreamBuilder<QuerySnapshot>(
              stream: _dbPath.getData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
        
                // Filter documents based on _roomId
                List<PathModel> pathList = snapshot.data!.docs
                    .where((doc) => doc.id.startsWith(_roomId))
                    .map((doc)=>doc.data() as PathModel).toList();
        
                return CustomPaint(
                  painter: DrawPainter(pathList),
                );
              },
            ),
          ),
        ),
    );
  }
}
