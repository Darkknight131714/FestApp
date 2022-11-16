import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

class TeamRegistrationScreen extends StatefulWidget {
  String docID;
  int size;
  TeamRegistrationScreen({required this.docID, required this.size});

  @override
  State<TeamRegistrationScreen> createState() =>
      _IndividualRegistrationScreenState();
}

class _IndividualRegistrationScreenState extends State<TeamRegistrationScreen> {
  int req = 0;
  List<dynamic> lis = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    req = 2 * widget.size + 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Registrations"),
        actions: [
          IconButton(
            onPressed: () async {
              List<List<String>> data = [];
              List<String> header = [];
              for (int i = 0; i < req; i++) {
                if (i == 0) {
                  header.add("Team Name");
                  continue;
                }
                if (i == 1) {
                  header.add("Mobile Number");
                  continue;
                }
                if (i % 2 == 0) {
                  header.add("Name");
                } else {
                  header.add("Email");
                }
              }
              data.add(header);
              List<String> row = [];
              for (int i = 0; i < lis.length; i++) {
                if (i % req == 0) {
                  data.add(row);
                  row = [];
                }
                row.add(lis[i]);
                // print(row);
              }
              data.add(row);
              exportCSV.myCSV(header, data);
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docID)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return const CircularProgressIndicator();
          } else {
            lis = snapshot.data!['registrations'];
            return ListView.builder(
              itemCount: snapshot.data!['registrations'].length,
              itemBuilder: (_, ind) {
                if (ind % req != 0) {
                  return SizedBox();
                } else {
                  return Card(
                    child: ListTile(
                      title: Text(
                          "Team Name: " + snapshot.data!['registrations'][ind]),
                      subtitle: Text(snapshot.data!['registrations'][ind + 2]),
                      trailing: Text(snapshot.data!['registrations'][ind + 1]),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
