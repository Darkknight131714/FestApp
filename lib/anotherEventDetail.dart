import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnotherEventDetailScreen extends StatefulWidget {
  String docID;
  String title;
  AnotherEventDetailScreen({required this.docID, required this.title});

  @override
  State<AnotherEventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<AnotherEventDetailScreen> {
  String date = "";
  String deadlineDate = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docID)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            var temp = new DateTime.fromMicrosecondsSinceEpoch(
                snapshot.data!['date'].microsecondsSinceEpoch);
            var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
            var inputDate = inputFormat.parse(temp.toString());
            var outputFormat = DateFormat('dd/MM/yyyy');
            date = outputFormat.format(inputDate);
            temp = new DateTime.fromMicrosecondsSinceEpoch(
                snapshot.data!['deadline'].microsecondsSinceEpoch);
            inputFormat = DateFormat('yyyy-MM-dd HH:mm');
            inputDate = inputFormat.parse(temp.toString());
            outputFormat = DateFormat('dd/MM/yyyy');
            deadlineDate = outputFormat.format(inputDate);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(width: double.infinity),
                  Image.network(
                    snapshot.data!['link'],
                    height: MediaQuery.of(context).size.height / 2,
                  ),
                  Text(
                    "Description: ${snapshot.data!['desc']}",
                    style: TextStyle(fontSize: 25),
                  ),
                  Divider(
                    color: Colors.orange,
                  ),
                  Text(
                    "Date: ${date}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Time: ${snapshot.data!['time']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Venue: ${snapshot.data!['venue']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Team Size: ${snapshot.data!['teamSize']}",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Deadline: ${deadlineDate}",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
