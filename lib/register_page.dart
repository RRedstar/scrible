import 'package:flutter/material.dart';
import 'package:train/db_services.dart';
import 'package:uuid/uuid.dart';

import 'classes.dart';
import 'home_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final DatabaseGeneralService _dbPlayer = DatabaseGeneralService<PlayerModel>(
      collectionName: 'Player', fromJson: PlayerModel.fromJson);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage("img/fond.webp"),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white38,
                        boxShadow: const [BoxShadow(offset: Offset(10, 10),
                          blurRadius: 15,
                          color: Colors.black54,
                        )]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text("Drawing Guess Game",
                            style: TextStyle(
                              fontFamily: "Corinto Town",
                              fontSize: 64,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            focusColor: Colors.white,
                              labelText: "Enter your Name",
                              border: OutlineInputBorder()),

                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                            onPressed: (){
                              if(_nameController.text.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please enter your name!")),
                                );
                              }
                              else {
                                String playerId = const Uuid().v4();

                                PlayerModel newPlayer = PlayerModel(
                                    id: playerId,
                                    name: _nameController.text,
                                    roomId: '',
                                    score: 0);

                                _dbPlayer.addData(playerId, newPlayer);

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(newPlayer)));
                              }
                            },
                            child: const Text("Enter"))
                      ],
                    ),
                  )
                ]))));
  }
}
