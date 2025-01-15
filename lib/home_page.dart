import 'package:flutter/material.dart';
import 'package:scrible/db_services.dart';
import 'package:scrible/painting_page.dart';
import 'package:scrible/stream_page.dart';

import 'classes.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final DatabaseService _dbService = DatabaseService();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//
//   void _addUser() {
//     UserModel new_user = UserModel(
//       name: _nameController.text,
//       age: double.parse(_ageController.text),
//     );
//     _dbService.addUser(new_user);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: "Name"),
//             ),
//             TextField(
//               controller: _ageController,
//               decoration: const InputDecoration(labelText: "Age"),
//             ),
//             userListView(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addUser,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   Widget userListView() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width - 200,
//       child: StreamBuilder(
//           stream: _dbService.getPath(),
//           builder: (context, snapshot) {
//             List pathList = snapshot.data?.docs ?? [];
//             if (userList.isEmpty) {
//               return const Text("No users found");
//             }
//             return ListView.builder(
//               itemCount: userList.length,
//               itemBuilder: (context, index) {
//                 var user = userList[index].data();
//                 String userId = userList[index].id;
//
//                 return ListTile(
//                   tileColor: Colors.indigoAccent,
//                   selectedColor: Colors.red,
//                   title: Text(user.name),
//                   subtitle: Text("${user.age}"),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.update),
//                         onPressed: () {
//                           UserModel updatedUser = UserModel(
//                             id: user.id,
//                             name: _nameController.text,
//                             age: double.parse(_ageController.text),
//                           );
//                           _dbService.updateUser(userId, updatedUser);
//                         },
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           _dbService.deleteUser(userId);
//                         }
//                       )
//                     ]
//                   )
//
//                 );
//               },
//             );
//           }),
//     );
//   }
// }

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainig App'),
      ),
      body: Center(
        child: Column(
          children: [
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaintPage()));
                  },
                child: const Text('Painting Page')),
            OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => StreamPage()));
                },
                child: const Text('Streaming Page')),

          ],
        )
      ),
    );
  }

}