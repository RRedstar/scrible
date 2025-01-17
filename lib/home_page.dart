import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:train/db_services.dart';
import 'package:train/painting_page.dart';
import 'package:train/room_creation_page.dart';
import 'package:train/stream_page.dart';
import 'classes.dart';

class HomePage extends StatefulWidget {
  PlayerModel player;

  HomePage(this.player);
  @override
  _HomePageState createState() => _HomePageState(player);
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final DatabaseGeneralService _dbPlayer = DatabaseGeneralService<PlayerModel>(
      collectionName: 'Player', fromJson: PlayerModel.fromJson);
  final DatabaseGeneralService<RoomModel> _dbRoom = DatabaseGeneralService(
      collectionName: "Rooms", fromJson: RoomModel.fromJson);

  PlayerModel player;

  _HomePageState(PlayerModel this.player);

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Prend en charge la fermeture de l'app
    switch (state) {
      case AppLifecycleState.paused:
        _dbPlayer.deleteData(player.id);
        print('********* Paused');
        break;

      case AppLifecycleState.resumed:
        _dbPlayer.addData(player.id, player);
        print('********* Resumed');
        break;

      case AppLifecycleState.detached:
        _dbPlayer.deleteData(player.id);
        print('********* Detached');
        break;

      case AppLifecycleState.inactive:
        _dbPlayer.deleteData(player.id);
        print('********* Inactive');
        break;

      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Redstar train',
        ),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Available Rooms:',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
                width: MediaQuery.sizeOf(context).width - 40,
                height: 400,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _dbRoom.getData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                    List<RoomModel> roomList = snapshot.data!.docs
                        .map((doc) => doc.data() as RoomModel)
                        .where((room) => !room.started)
                        .toList();

                    return ListView.builder(
                      itemCount: roomList.length,
                      itemBuilder: (context, index) {
                        return RoomTile(roomList[index]);
                      },
                    );
                  },
                )),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
              onPressed: () {
                WidgetsBinding.instance.removeObserver(this);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RoomCreationPage(player.id)));
              },
              child: const Text('Create Room')),
          const SizedBox(height: 30)
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
      subtitle: Text('${room.players.length}/${room.nbMaxPlayer}'),
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
    ));
  }
}
