import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/notes.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/data/bookshelper.dart';
import 'package:flutter_restart/flutter_restart.dart';
import 'favoriteScreen.dart';
import 'package:flash_chat/data/book.dart';
import 'package:flash_chat/ui.dart';
//import 'package:flutter/src/rendering/box.dart';

const apikey = 'AIzaSyB-8E8f9qQBInzUo-Dn64AcveYRrE5pqqY';
const booksURL = '';
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
final _firebaseAuth = FirebaseAuth.instance;
User loggedInUser;

class HomeBooks extends StatelessWidget {
  static const id = 'home_books';
  @override
  // _HomeBooksState createState() => _HomeBooksState();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Books',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
    //throw UnimplementedError();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BooksHelper helper;
  List<dynamic> books = List<dynamic>();
  int booksCount;
  TextEditingController txtSearchController;
  @override
  void initState() {
    helper = BooksHelper();
    txtSearchController = TextEditingController();
    initialize();
    super.initState();
  }

  // void _restartApp() async {
  //   FlutterRestart.restartApp();
  // }

  @override
  Widget build(BuildContext context) {
    bool isSmall = false;
    if (MediaQuery.of(context).size.width < 600) {
      isSmall = true;
    }

    return Scaffold(
        appBar: AppBar(
          //title: Text('My Books'),
          title: Hero(
              tag: 'logo',
              child: Image.asset('images/booklogo.png', fit: BoxFit.cover)),
          actions: <Widget>[
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: (isSmall) ? Icon(Icons.home) : Text('Home')),
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.chat_bubble) : Text('Chat'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()));
              },
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: (isSmall) ? Icon(Icons.note_rounded) : Text('Notes'),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NotesPage()));
              },
            ),
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: (isSmall) ? Icon(Icons.star) : Text('Favorites')),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()));
              },
            ),
            InkWell(
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: (isSmall) ? Icon(Icons.logout) : Text('Logout')),
              onTap: () {
                _auth.signOut();
                Future<void> logout() async {
                  try {
                    // await _firebaseAuth.signOut();
                    await FirebaseAuth.instance.signOut();
                  } catch (e, st) {
                    FlutterError.reportError(
                        FlutterErrorDetails(exception: e, stack: st));
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(children: [
              Text('Search book'),
              Container(
                  padding: EdgeInsets.all(20),
                  width: 180,
                  child: TextField(
                    controller: txtSearchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (text) {
                      helper.getBooks(text).then((value) {
                        books = value;
                        setState(() {
                          books = books;
                        });
                      });
                    },
                  )),
              Container(
                  padding: EdgeInsets.all(20),
                  child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () =>
                          helper.getBooks(txtSearchController.text))),
            ]),
          ),
          Padding(
              padding: EdgeInsets.all(20),
              child: (isSmall)
                  ? BooksList(books, false)
                  : BooksTable(books, false)),
        ])));
  }

  Future initialize() async {
    books = await helper.getBooks('Flutter');
    setState(() {
      booksCount = books.length;
      books = books;
    });
  }
}

// Container(
// padding: EdgeInsets.all(20),
// child: IconButton(
// icon: Icon(Icons.logout),
// onPressed: () {
// _auth.signOut();
//
// Future<void> logout() async {
// try {
// await _firebaseAuth.signOut();
// } catch (e, st) {
// FlutterError.reportError(
// FlutterErrorDetails(exception: e, stack: st));
// }
// }
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => WelcomeScreen()));
// }),
// ),
