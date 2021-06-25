import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_help.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputField("First Name", "Enter First Name", firstController),
            const SizedBox(
              height: 20,
            ),
            inputField("Last Name", "Enter Last Name", lastController),
            const SizedBox(
              height: 20,
            ),
            inputField("Email", "Enter Email", emailController),
            const SizedBox(
              height: 20,
            ),
            inputField("Password", "Enter Password", passController,
                isObscureText: true),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseHelper.createAccount(
                            emailController.text, passController.text);
                    if (userCredential.user != null) {
                      User? user = FirebaseAuth.instance.currentUser;
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .set({
                        'firstname': firstController.text,
                        'lastname': lastController.text,
                        'admin': false
                      });

                      Navigator.pop(context);
                    }
                  } catch (e) {
                    print("failed");
                  }
                },
                child: Text("Register"))
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
