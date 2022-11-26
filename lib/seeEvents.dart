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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
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
                  String deadline = "";
                  if (snapshot.data!.docs[ind]['register']) {
                    temp = new DateTime.fromMicrosecondsSinceEpoch(snapshot
                        .data!.docs[ind]['deadline'].microsecondsSinceEpoch);
                    inputDate = inputFormat.parse(temp.toString());
                    deadline = outputFormat.format(inputDate);
                  }
                  return GestureDetector(
                    onTap: () {
                      if (snapshot.data!.docs[ind]['register']) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return RegisterEventDetailScreen(
                            docID: snapshot.data!.docs[ind].id,
                            fest: snapshot.data!.docs[ind]['fest'],
                            title: snapshot.data!.docs[ind]['title'],
                          );
                        }));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return EventDetailScreen(
                              doc: snapshot.data!.docs[ind]);
                        }));
                      }
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              snapshot.data!.docs[ind]['title'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: Image.network(
                                  snapshot.data!.docs[ind]['link'],
                                  width: 300,
                                  height: 200,
                                  fit: BoxFit.fill),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(snapshot.data!.docs[ind]['desc']),
                            ),
                            Divider(
                              color: Colors.orange,
                            ),
                            Text("Event Date and Time"),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(date),
                                Text(snapshot.data!.docs[ind]['time']),
                              ],
                            ),
                            Divider(
                              color: Colors.orange,
                            ),
                            if (snapshot.data!.docs[ind]['register'])
                              Column(
                                children: [
                                  Card(
                                    color: Colors.redAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("OPEN FOR REGISTRATION"),
                                    ),
                                  ),
                                  Text("Registration Deadline: ${deadline}"),
                                ],
                              ),
                            if (!snapshot.data!.docs[ind]['register'])
                              Card(
                                color: Colors.redAccent,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("OPEN FOR EVERYONE"),
                                ),
                              ),
                          ],
                        ),
                      ),
                      // child: ListTile(
                      //   tileColor: snapshot.data!.docs[ind]['register']
                      //       ? Colors.green
                      //       : null,
                      //   leading:
                      //       Text(snapshot.data!.docs[ind]['fest'].toUpperCase()),
                      //   title: Text(snapshot.data!.docs[ind]['title']),
                      //   subtitle: Text(snapshot.data!.docs[ind]['desc']),
                      //   isThreeLine: true,
                      //   trailing: Column(
                      //     children: [
                      //       Text(date),
                      //       Text(snapshot.data!.docs[ind]['time'])
                      //     ],
                      //   ),
                      //   onTap: () {
                      //     if (snapshot.data!.docs[ind]['register']) {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (_) {
                      //         return RegisterEventDetailScreen(
                      //           docID: snapshot.data!.docs[ind].id,
                      //           fest: snapshot.data!.docs[ind]['fest'],
                      //           title: snapshot.data!.docs[ind]['title'],
                      //         );
                      //       }));
                      //     } else {
                      //       Navigator.push(context,
                      //           MaterialPageRoute(builder: (_) {
                      //         return EventDetailScreen(
                      //             doc: snapshot.data!.docs[ind]);
                      //       }));
                      //     }
                      //   },
                      // ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
