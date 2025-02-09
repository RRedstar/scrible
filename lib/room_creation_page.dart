import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:train/lobby_page.dart';
import 'package:uuid/uuid.dart';
import 'classes.dart';
import 'db_services.dart';
import 'painting_page.dart';

class RoomCreationPage extends StatefulWidget {
  final String creatorId;

  const RoomCreationPage(this.creatorId);

  @override
  _RoomCreationPageState createState() => _RoomCreationPageState(creatorId);
}

class _RoomCreationPageState extends State<RoomCreationPage> {
  // Controllers and variables
  final String creatorId;

  _RoomCreationPageState(this.creatorId);

  final TextStyle labelStyle = const TextStyle(
      fontSize: 16, color: Colors.indigo, fontWeight: FontWeight.bold);
  final TextEditingController _roomNameCtrl = TextEditingController();
  final DatabaseGeneralService<RoomModel> _dbRoom = DatabaseGeneralService(
    collectionName: "Rooms",
    fromJson: RoomModel.fromJson,
  );
  final DatabaseGeneralService<PlayerModel> _dbPlayer = DatabaseGeneralService(
    collectionName: "Player",
    fromJson: PlayerModel.fromJson,
  );

  String _language = 'En'; // Default language
  int _nbRound = 4; // Default number of rounds
  int _nbMaxPlayer = 4; // Default number of players
  int _time = 60; // Default time per round

  createRoom() async {
    if (_roomNameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room name cannot be empty!")),
      );
      return;
    }

    DocumentReference creator = await _dbPlayer.getDocument(creatorId);

    // Get creator player
    String roomId = const Uuid().v4().substring(0, 12);
    RoomModel newRoom = RoomModel(
      id: roomId,
      roomName: _roomNameCtrl.text,
      nbMaxPlayer: _nbMaxPlayer,
      nbRound: _nbRound,
      time: _time,
      language: _language,
      started: false,
      players: <DocumentReference>[creator],
    );

    PlayerModel player = await creator.get().then(
      (doc) => doc.data() as PlayerModel
    );

    player.roomId = roomId;

    // Add room to Firestore
    _dbRoom.addData(roomId, newRoom);
    _dbPlayer.updateData(creatorId, player);

    // Navigate to PaintPage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LobbyPage(roomId: roomId, isCreator: true,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Room Name
              TextField(
                controller: _roomNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Room Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Language Dropdown
              const Text("Language",
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'En', child: Text('English')),
                  DropdownMenuItem(value: 'Fr', child: Text('Français')),
                ],
                onChanged: (value) {
                  setState(() {
                    _language = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Number of Rounds Slider
              Text("Number of Rounds: $_nbRound", style: labelStyle),
              Slider(
                value: _nbRound.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: _nbRound.toString(),
                onChanged: (value) {
                  setState(() {
                    _nbRound = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20),

              // Time per Round Dropdown
              Text("Time per Round", style: labelStyle),
              DropdownButton<int>(
                value: _time,
                items: const [
                  DropdownMenuItem(value: 60, child: Text('60 seconds')),
                  DropdownMenuItem(value: 120, child: Text('120 seconds')),
                  DropdownMenuItem(value: 180, child: Text('180 seconds')),
                ],
                onChanged: (value) {
                  setState(() {
                    _time = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Max Number of Players Slider
              Text("Number of Players: $_nbMaxPlayer", style: labelStyle),
              Slider(
                value: _nbMaxPlayer.toDouble(),
                min: 2,
                max: 10,
                divisions: 8,
                label: _nbMaxPlayer.toString(),
                onChanged: (value) {
                  setState(() {
                    _nbMaxPlayer = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20),

              // Create Room Button
              Center(
                child: OutlinedButton(
                  onPressed: () => createRoom(),
                  child: const Text('Create Room'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roomNameCtrl.dispose();
    super.dispose();
  }
}
