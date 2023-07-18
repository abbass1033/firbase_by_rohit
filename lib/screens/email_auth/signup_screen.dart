

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create an account"),
      ),

      body: SafeArea(
        child: ListView(
          children: [

            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: "Email Address"
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: "Password"
                    ),
                  ),

                  SizedBox(height: 10,),

                  TextField(
                    controller: cPasswordController,
                    decoration: InputDecoration(
                        labelText: "Confirm Password"
                    ),
                  ),

                  SizedBox(height: 20,),

                  CupertinoButton(
                    onPressed: () {
                      createAccount();
                    },
                    color: Colors.blue,
                    child: Text("Create Account"),
                  )

                ],
              ),
            )

          ],
        ),
      ),
    );
  }


  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if (email == "" || password == "" || cPassword == "") {
      log("Please fill all the details!");
    }
    else if (password != cPassword) {
      log("Passwords do not match!");
    }
    else{

      try{

        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        if(userCredential.user != null) {
          Navigator.pop(context);
        }

      }
      on FirebaseException catch(e){
        log(e.code.toString());
      }

    }
  }

}
