import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/detailEvent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .orderBy('date')
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                var temp = new DateTime.fromMicrosecondsSinceEpoch(
                    snapshot.data!.docs[ind]['date'].microsecondsSinceEpoch);
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                var inputDate = inputFormat.parse(temp.toString());
                var outputFormat = DateFormat('dd/MM/yyyy');
                String date = outputFormat.format(inputDate);
                return Card(
                  child: ListTile(
                    leading: Text(snapshot.data!.docs[ind]['fest']),
                    title: Text(snapshot.data!.docs[ind]['title']),
                    subtitle: Text(snapshot.data!.docs[ind]['desc']),
                    isThreeLine: true,
                    trailing: Column(
                      children: [
                        Text(date),
                        Text(snapshot.data!.docs[ind]['time'])
                      ],
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return EventDetailScreen(doc: snapshot.data!.docs[ind]);
                      }));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
