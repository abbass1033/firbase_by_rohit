
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  File? profilepic;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(15),
      child: Column(
        children: [

        CupertinoButton(
          onPressed: ()async{
            XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

            if(selectedImage != null) {
              File convertedFile = File(selectedImage.path);
              setState(() {
                profilepic = convertedFile;
              });
              setState(() {
                profilepic == null;
              });
              log("Image selected!");
            }
            else {
              log("No image selected!");
            }


          },
            child: CircleAvatar(radius: 40,
              backgroundImage: (profilepic != null) ? FileImage(profilepic!) : null,
              backgroundColor: Colors.grey,),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                hintText: "Name"
            ),
          ),

          const SizedBox(height: 10,),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
                hintText: "Email Address"
            ),
          ),

          const SizedBox(height: 10,),

          TextField(
            controller: ageController,
            decoration: const InputDecoration(
                hintText: "Age"
            ),
          ),

          const SizedBox(height: 10,),

          CupertinoButton(
            onPressed: () {
              saveUser();
            },
            child: const Text("Save"),
          ),

          const SizedBox(height: 20,),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").orderBy("age").snapshots(),
            builder: (context, snapshot) {

              if(snapshot.connectionState == ConnectionState.active) {
                if(snapshot.hasData && snapshot.data != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        Map<String, dynamic> userMap = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(userMap["profile"]),
                          ),
                          title: Text(userMap["name"] + "(${userMap["age"]})"),
                          subtitle: Text(userMap["email"]),
                          trailing: IconButton(
                            onPressed: () {
                              // Delete
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );

                      },
                    ),
                  );
                }
                else {
                  return Text("No data!");
                }
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

            },
          ),


        ],
      ),
      ),
      ),

    );
  }


  void saveUser()async{
    String name = nameController.text.toString();
    String email = emailController.text.toString();
    String ageString = ageController.text.toString();

    int age = int.parse(ageString);

    nameController.clear();
    emailController.clear();
    ageController.clear();

    if(name != "" && email != "" && profilepic !=null){

      UploadTask uploadTask =  FirebaseStorage.instance.ref().child("profile").child("newAgain").child(Uuid().v1()).putFile(profilepic!);

      StreamSubscription taskSubScription = uploadTask.snapshotEvents.listen((snapshot) {
        double percentage = snapshot.bytesTransferred/snapshot.totalBytes*100;
        log(percentage.toString());
      });
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      taskSubScription.cancel();

      Map<String , dynamic> userData = {
        "name" : name,
        "email" : email,
        "age" : age,
        "profile" : downloadUrl,
        "simpleArray" : [name , email , age]
      };
      FirebaseFirestore.instance.collection("users").add(userData);
      log("users created");
    }
    else{
      log("please enter the fields");
    }

  }
}
