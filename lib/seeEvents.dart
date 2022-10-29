import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/detailEvent.dart';
import 'package:festapp/registerEventDetailScreen.dart';
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
                if (temp.isBefore(DateTime.now())) {
                  return SizedBox();
                }
                var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                var inputDate = inputFormat.parse(temp.toString());
                var outputFormat = DateFormat('dd/MM/yyyy');
                String date = outputFormat.format(inputDate);
                return Card(
                  child: ListTile(
                    tileColor: snapshot.data!.docs[ind]['register']
                        ? Colors.green
                        : null,
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
                      if (snapshot.data!.docs[ind]['register']) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return RegisterEventDetailScreen(
                              docID: snapshot.data!.docs[ind].id);
                        }));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return EventDetailScreen(
                              doc: snapshot.data!.docs[ind]);
                        }));
                      }
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
