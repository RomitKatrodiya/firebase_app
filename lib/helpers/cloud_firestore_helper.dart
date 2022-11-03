import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference studentsRef;

  connectionWithStudentsCollection() {
    studentsRef = firebaseFirestore.collection('students');
  }

  Future<void> insertData() async {
    connectionWithStudentsCollection();
    await studentsRef.doc("4").set({
      "name": "Romit",
      "age": 10,
      "city": "Surat",
    });
  }

  Stream<QuerySnapshot<Object?>> selectRecords() {
    connectionWithStudentsCollection();
    return studentsRef.snapshots();
  }
}
