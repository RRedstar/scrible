import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'classes.dart';
import 'db_services.dart';
import 'painting_page.dart';
import 'stream_page.dart';

class LobbyPage extends StatefulWidget {
  final String roomId;
  final bool isCreator;

  LobbyPage({required this.roomId, required this.isCreator});

  @override
  _LobbyPageState createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  RoomModel? currentRoom;

  final DatabaseGeneralService<RoomModel> _dbRoom = DatabaseGeneralService(
    collectionName: "Rooms",
    fromJson: RoomModel.fromJson,
  );
  final DatabaseGeneralService<PlayerModel> _dbPlayer = DatabaseGeneralService(
    collectionName: 'Player',
    fromJson: PlayerModel.fromJson,
  );

  @override
  void dispose() {
    super.dispose();
    onDetached();
  }

  void onDetached(){
    if (currentRoom is RoomModel && widget.isCreator) {
      _dbRoom.deleteData(currentRoom!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lobby'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Room Info
            StreamBuilder<QuerySnapshot>(
              stream: _dbRoom.getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Room was closed!');
                }

                final roomList = snapshot.data!.docs
                    .map((doc) => doc.data() as RoomModel)
                    .where((room) => room.id == widget.roomId)
                    .toList();

                if (roomList.isEmpty) {
                  return const Text('Room was closed!');
                }

                currentRoom = roomList.first;

                if (currentRoom!.started) {
                  Future.microtask(() => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          StreamPage(roomId: currentRoom!.id),
                    ),
                  ));
                  return const Text('Room started');
                }

                return RoomInfo(currentRoom!);
              },
            ),

            const SizedBox(height: 20),

            // Player List
            StreamBuilder<QuerySnapshot>(
              stream: _dbPlayer.getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Error: No player in this room!');
                }

                final playerList = snapshot.data!.docs
                    .map((doc) => doc.data() as PlayerModel)
                    .where((player) => player.roomId == widget.roomId)
                    .toList();

                if (playerList.isEmpty) {
                  return const Text('Error: No player in this room!');
                }

                return PlayerList(playerList);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget RoomInfo(RoomModel room) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        Text("Room name: ${room.roomName}"),
        Text("Language: ${room.language}"),
        Text("Number of rounds: ${room.nbRound}"),
        Text("Time per round: ${room.time}s"),
        Text("Number of players: ${room.players.length}/${room.nbMaxPlayer}"),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget PlayerList(List<PlayerModel> playerList) {
    final canStartGame = widget.isCreator &&
        currentRoom != null &&
        currentRoom!.players.length > 1;

    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: playerList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(playerList[index].name),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        if (widget.isCreator)
          canStartGame
              ? ElevatedButton(
            onPressed: () {
              setState(() {
                currentRoom!.started = true;
              });
              _dbRoom.updateData(widget.roomId, currentRoom!);

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaintPage(roomId: currentRoom!.id),
              ));
            },
            child: const Text("Start Game"),
          )
              : const Text(
            "The game can be started when there are at least two players in the room.",
          ),
      ],
    );
  }
}
