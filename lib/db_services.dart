
import 'package:cloud_firestore/cloud_firestore.dart';

import 'classes.dart';


class DatabaseGeneralService<T extends JsonConvertible> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName;

  late final CollectionReference<T> _pathRef;

  DatabaseGeneralService({
    required this.collectionName,
    required T Function(Map<String, dynamic>) fromJson
  }) {
    _pathRef = _firestore.collection(collectionName).withConverter<T>(
      fromFirestore: (snapshots, _) => fromJson(snapshots.data()!),
      toFirestore: (data, _) => data.toJson(),
    );
  }

  Stream<QuerySnapshot<T>> getData() {
    return _pathRef.snapshots();
  }

  Future<void> addData(String docId, T data) async {
    await _pathRef.doc(docId).set(data);
  }

  Future<void> updateData(String userId, T data) async {
    await _pathRef.doc(userId).update(data.toJson());
  }

  Future<void> deleteData(String userId) async {
    await _pathRef.doc(userId).delete();
  }

  Future<void> clearCollection(String roomId) async {
    QuerySnapshot<T> snapshot = await _pathRef.get();

    WriteBatch batch = _firestore.batch();
    for (DocumentSnapshot<T> doc in snapshot.docs) {
      if (doc.id.contains(roomId)){
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
  }
}

