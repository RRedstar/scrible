import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrible/db_services.dart';
import 'package:scrible/painting_page.dart';
import 'package:scrible/room_creation_page.dart';
import 'package:scrible/stream_page.dart';
import 'classes.dart';

class HomePage extends StatefulWidget {
  String playerId;

  HomePage(this.playerId);
  @override
  _HomePageState createState() => _HomePageState(playerId);
}

class _HomePageState extends State<HomePage> {
  final DatabaseGeneralService _dbPlayer = DatabaseGeneralService<PlayerModel>(
      collectionName: 'Player', fromJson: PlayerModel.fromJson);
  final DatabaseGeneralService<RoomModel> _dbRoom = DatabaseGeneralService(
      collectionName: "Rooms", fromJson: RoomModel.fromJson);

  String playerId;

  _HomePageState(String this.playerId);
  
  void dispose() {
    _dbPlayer.deleteData(playerId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redstar Scrible',),
      ),
      body: Center(
          child: Column(
        children: [
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

  Card RoomTile(RoomModel room) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(room.language),
        ),
        title: Text(room.roomName),
        subtitle: Text('${room.nbUser}/${room.nbMaxUser}'),
        trailing: IconButton(
          icon: const Icon(Icons.open_in_browser),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StreamPage(roomId: room.id)));
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaintPage(roomId: room.id)));
        },
      )
    );
  }
}

