import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:train/db_services.dart';
import 'package:train/painting_page.dart';
import 'package:train/room_creation_page.dart';
import 'package:train/stream_page.dart';
import 'package:uuid/uuid.dart';
import 'classes.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseGeneralService<RoomModel> _dbRoom = DatabaseGeneralService(
      collectionName: "Rooms", fromJson: RoomModel.fromJson);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainig App'),
      ),
      body: Center(
          child: Column(
        children: [
          // OutlinedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const PaintPage(roomId: 'R1')
          //       ));
          //     },
          //     child: const Text('Painting Page')),
          // OutlinedButton(
          //     onPressed: () {
          //       Navigator.of(context).push(MaterialPageRoute(
          //           builder: (context) => const StreamPage(roomId: 'R1')));
          //     },
          //     child: const Text('Streaming Page')),


          const SizedBox(height: 20),
          const Text('Available Rooms:', style: TextStyle(fontSize: 20,color: Colors.indigo,fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Container(
              width: MediaQuery.sizeOf(context).width - 40,
              height: 400,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _dbRoom.getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  List<RoomModel> roomList = snapshot.data!.docs
                      .map((doc){
                    RoomModel r = doc.data() as RoomModel;
                    // Récupérer l'id du document et mettre a jour celui du RoomModel
                    return r;
                  } )
                      .toList();

                  return ListView.builder(
                    itemCount: roomList.length,
                    itemBuilder: (context, index) {
                      return RoomTile(roomList[index]);
                    },
                  );
                },
              )),

          const SizedBox(height: 20),

          OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RoomCreationPage()));
              },
              child: const Text('Create Room')),
        ],
      )),
    );
  }

  ListTile RoomTile(RoomModel room) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(room.language),
      ),
      title: Text(room.roomName),
      subtitle: Text('${room.nbUser}/${room.nbMaxUser}'),
      trailing: IconButton(
        icon: const Icon(Icons.open_in_browser),
        onPressed: () {},
      ),
      onTap: () {
        print("Room id : ${room.id}");
      },
    );
  }
}

