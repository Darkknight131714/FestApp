import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnotherEventDetailScreen extends StatefulWidget {
  String docID;
  AnotherEventDetailScreen({required this.docID});

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
        title: Text("Registerable Event Detail"),
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
            return Column(
              children: [
                SizedBox(width: double.infinity),
                Image.network(
                  snapshot.data!['link'],
                  height: MediaQuery.of(context).size.height / 2,
                ),
                Text("Fest: ${snapshot.data!['fest']}"),
                Text("Title: ${snapshot.data!['title']}"),
                Text("Description: ${snapshot.data!['desc']}"),
                Text("Date: ${date}"),
                Text("Time: ${snapshot.data!['time']}"),
                Text("Venue: ${snapshot.data!['venue']}"),
                Text("Team Size: ${snapshot.data!['teamSize']}"),
                Text("Deadline: ${deadlineDate}"),
              ],
            );
          }
        },
      ),
    );
  }
}
