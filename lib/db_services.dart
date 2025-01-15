
import 'package:cloud_firestore/cloud_firestore.dart';

import 'classes.dart';

const String _userCollection = "Path";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _pathRef;

  DatabaseService() {
    _pathRef = _firestore.collection(_userCollection).withConverter<PathModel>(
      fromFirestore: (snapshots, _) => PathModel.fromJson(snapshots.data()!),
      toFirestore: (path, _) => path.toJson()
    );
  }

  Stream<QuerySnapshot> getPath(){
    return _pathRef.snapshots();
  }

  void addPath(String pathId, PathModel path) async {
    _pathRef.doc(pathId).set(path);
  }

  void updatePath(String userId, PathModel path) async {
    _pathRef.doc(userId).update(path.toJson());
  }

  void deletePath(String userId) async {
    _pathRef.doc(userId).delete();
  }

  void clearPath() async {
    // Retrieve all documents in the collection
    QuerySnapshot snapshot = await _pathRef.get();

    // Use a batch to delete documents
    WriteBatch batch = _firestore.batch();
    for (DocumentSnapshot doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // Commit the batch
    await batch.commit();
  }
}