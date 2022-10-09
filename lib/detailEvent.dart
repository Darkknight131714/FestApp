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
        title: Text("Event Detail"),
      ),
      body: Column(
        children: [
          SizedBox(width: double.infinity),
          Image.network(
            widget.doc['link'],
            height: MediaQuery.of(context).size.height / 2,
          ),
          Text("Fest: ${widget.doc['fest']}"),
          Text("Title: ${widget.doc['title']}"),
          Text("Description: ${widget.doc['desc']}"),
          Text("Date: ${date}"),
          Text("Time: ${widget.doc['time']}"),
          Text("Venue: ${widget.doc['venue']}"),
        ],
      ),
    );
  }
}
