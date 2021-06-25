import 'package:fan_page/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:developer' as developer;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  final UserCredential userCredential;
  final DocumentSnapshot snapshot;
  const HomeScreen(this.userCredential, this.snapshot);
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController newTextController = TextEditingController();
  CollectionReference messagesRef =
      FirebaseFirestore.instance.collection('messages');
  CollectionReference usersData =
      FirebaseFirestore.instance.collection('messages');

  User? currentUser = FirebaseAuth.instance.currentUser;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Welcome"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Log Out',
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Log Out Alert'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        auth.signOut().then((res) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        });
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            )
          ]),
      body: Center(
        child: StreamBuilder(
          stream: messagesRef.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView(
              children: snapshot.data!.docs.map((messages) {
                return Center(
                  child: ListTile(
                    title: Text(messages['message']),
                    subtitle: Text(messages['time'].toDate().toString()),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: _getFAB(widget.snapshot),
    );
  }

  Widget _getFAB(DocumentSnapshot<Object?> snapshot) {
    if (!snapshot['admin']) {
      return Container();
    } else {
      return FloatingActionButton(
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Add a message'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: newTextController,
                        decoration:
                            InputDecoration(labelText: "Enter a message"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              messagesRef.add({
                                'message': newTextController.text,
                                'time': FieldValue.serverTimestamp()
                              });
                              newTextController.clear();
                            },
                            child: const Text('Add'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
          tooltip: 'Add Message',
          child: Icon(Icons.add));
    }
  }
}
