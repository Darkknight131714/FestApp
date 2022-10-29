import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/func.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

List<String> names = [];

class TeamRegisterScreen extends StatefulWidget {
  String docID;
  int size;
  TeamRegisterScreen({required this.docID, required this.size});

  @override
  State<TeamRegisterScreen> createState() => _TeamRegisterScreenState();
}

class _TeamRegisterScreenState extends State<TeamRegisterScreen> {
  List<String> emails = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    names = [];
    emails.add(mainUser.email);
    names.add(mainUser.name);
    for (int i = 1; i < widget.size; i++) {
      emails.add("none");
      names.add("none");
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Team Details"),
        actions: [
          IconButton(
              onPressed: () async {
                List<String> newEmails = emails.toSet().toList();
                if (newEmails.length < widget.size) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "There are a few duplicate entries. Please correct them."),
                    ),
                  );
                } else {
                  int val = await checkEmails(emails);
                  if (val != widget.size) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Few of the users are not registered."),
                      ),
                    );
                    return;
                  }
                  String status =
                      await checkAlreadyRegistered(emails, widget.docID);
                  if (status == '@accepted') {
                    DocumentReference event = FirebaseFirestore.instance
                        .collection('events')
                        .doc(widget.docID);
                    await event.get().then((snap) {
                      List<dynamic> eventEmails = snap['emails'];
                      List<dynamic> eventRegistrations = snap['registrations'];
                      eventRegistrations.add(mainUser.mobile);
                      for (int i = 0; i < emails.length; i++) {
                        eventEmails.add(emails[i]);
                        eventRegistrations.add(names[i]);
                        eventRegistrations.add(emails[i]);
                      }
                      snap.reference.update({
                        'emails': eventEmails,
                        'registrations': eventRegistrations,
                      });
                    });
                    DocumentReference doc = FirebaseFirestore.instance
                        .collection('events')
                        .doc(widget.docID);
                    await doc.get().then((snap) {
                      for (int i = 0; i < emails.length; i++) {
                        FirebaseFirestore.instance
                            .collection('registrations')
                            .add({
                          'email': emails[i],
                          'docID': widget.docID,
                          'time': snap['date'],
                          'title': snap['title'],
                          'desc': snap['desc'],
                          'venue': snap['venue'],
                          'link': snap['link'],
                        });
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Team successfully registered."),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${status} is already registered"),
                      ),
                    );
                    return;
                  }
                }
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: ListView.builder(
            itemCount: widget.size - 1,
            itemBuilder: (_, ind) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Email",
                  ),
                  onChanged: (value) {
                    setState(() {
                      emails[ind + 1] = value;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
