import 'package:flash_chat/screens/addNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'editNote.dart';

class NotesPage extends StatelessWidget {
  final ref = FirebaseFirestore.instance.collection('notes');
  static const id = "notes";
  final _auth = FirebaseAuth.instance;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.hasData ? snapshot.data.docs.length : 0,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditNote(
                                  docToEdit: snapshot.data.docs[index],
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    height: 150.0,
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        Text(snapshot.data.docs[index].data()['title']),
                        Text(snapshot.data.docs[index].data()['content']),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
