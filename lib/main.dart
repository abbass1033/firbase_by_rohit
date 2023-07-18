import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_by_rohit/screens/email_auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FirebaseFirestore _firebase = FirebaseFirestore.instance;

  //get data from
 /* DocumentSnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").doc("a2o752lLe91dVu6KVv7D").get();
 log("data : ${querySnapshot.data().toString()}");
  */


  Map<String , dynamic> newUserData = {

    "name" : "salam khan",
    "email" : "salman@gmail.com"
  };

  //add document

  //await _firebase.collection("users").add(newUserData);


  //if you want set document id

 // await _firebase.collection("users").doc("new_id_here").set(newUserData);


  //update data

/*  await _firebase.collection("users").doc("new_id_here").update({
    "email" : "saadkhan@gmail.com"
  });*/


  //delete document

  await _firebase.collection("users").doc("new_id_here").delete();


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

