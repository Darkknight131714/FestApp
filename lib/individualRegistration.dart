import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

class IndividualRegistrationScreen extends StatefulWidget {
  String docID;
  IndividualRegistrationScreen({required this.docID});

  @override
  State<IndividualRegistrationScreen> createState() =>
      _IndividualRegistrationScreenState();
}

class _IndividualRegistrationScreenState
    extends State<IndividualRegistrationScreen> {
  int req = 3;
  List<dynamic> lis = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              List<String> header = ["Mobile Number", "Name", "Email"];
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
                if (ind % 3 != 0) {
                  return SizedBox();
                } else {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data!['registrations'][ind + 1]),
                      subtitle: Text(snapshot.data!['registrations'][ind + 2]),
                      trailing: Text(snapshot.data!['registrations'][ind]),
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
