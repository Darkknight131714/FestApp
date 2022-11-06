import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({Key? key}) : super(key: key);

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  String email = "";
  TextEditingController cont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Admin"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: cont,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                hintText: "Email of User",
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              int count = 0;
              bool flag = false;
              await FirebaseFirestore.instance
                  .collection('users')
                  .where('email', isEqualTo: email)
                  .get()
                  .then((QuerySnapshot querySnapshot) {
                for (var documentSnapshot in querySnapshot.docs) {
                  count++;
                  if (documentSnapshot['fest'] != '') {
                    flag = true;
                    break;
                  } else {
                    documentSnapshot.reference.update({
                      'fest': mainUser.fest,
                    });
                    break;
                  }
                }
              });
              if (count == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No User with this email exists")));
                cont.clear();
                email = "";
                setState(() {});
              } else if (flag) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "This user already has admin privilege for some fest.")));
                cont.clear();
                email = "";
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("User given admin privelege successfully")));
                cont.clear();
                email = "";
                setState(() {});
              }
            },
            child: Text("Give Admin Privilege"),
          ),
        ],
      ),
    );
  }
}
