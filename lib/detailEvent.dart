import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailScreen extends StatefulWidget {
  DocumentSnapshot doc;
  EventDetailScreen({required this.doc});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  String date = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var temp = new DateTime.fromMicrosecondsSinceEpoch(
        widget.doc['date'].microsecondsSinceEpoch);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(temp.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    date = outputFormat.format(inputDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc['title']),
        actions: [
          Text(
            widget.doc['fest'].toUpperCase(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(width: double.infinity),
            InteractiveViewer(
              child: Image.network(
                widget.doc['link'],
                height: MediaQuery.of(context).size.height / 2,
                width: 300,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Description: ${widget.doc['desc']}",
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
              "Time: ${widget.doc['time']}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Venue: ${widget.doc['venue']}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
