import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
}
