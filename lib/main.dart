import 'package:fan_page/firebase_help.dart';
import 'package:fan_page/homepage.dart';
import 'package:fan_page/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fan Page',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Saads Fan Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputField("Email", "Enter Email", widget.emailController),
            const SizedBox(
              height: 20,
            ),
            inputField("Password", "Enter Password", widget.passController,
                isObscureText: true),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential =
                            await FirebaseHelper.signInWithEmailPass(
                                widget.emailController.text,
                                widget.passController.text);
                        if (userCredential.user != null) {
                          var uID = userCredential.user!.uid;
                          var snapshot = await FirebaseFirestore.instance
                              .collection('users')
                              .doc('$uID')
                              .get();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen(userCredential, snapshot)));
                        }
                      } catch (e) {
                        print("User not found");
                      }
                    },
                    child: Text("Sign In")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()));
                    },
                    child: Text("Register")),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  UserCredential? userCredential =
                      await FirebaseHelper.signInWithGoogle(context: context);
                  if (userCredential != null) {
                    var uID = userCredential.user!.uid;
                    var snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc('$uID')
                        .get();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(userCredential, snapshot)));
                  }
                },
                child: Text("Sign in with Google")),
          ],
        ),
      ),
    );
  }

  Widget inputField(
      String title, String hintText, TextEditingController controller,
      {bool isObscureText = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextField(
              obscureText: isObscureText,
              controller: controller,
              decoration: InputDecoration(hintText: hintText)),
        ],
      ),
    );
  }
}
