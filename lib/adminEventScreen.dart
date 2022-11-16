import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/editEvent.dart';
import 'package:festapp/individualRegistration.dart';
import 'package:festapp/main.dart';
import 'package:festapp/registerTeam.dart';
import 'package:festapp/seeArchived.dart';
import 'package:festapp/teamRegistration.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class AdminEventScreen extends StatefulWidget {
  const AdminEventScreen({Key? key}) : super(key: key);

  @override
  State<AdminEventScreen> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<AdminEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See your Events"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return SeeArchived();
              }));
            },
            icon: Icon(Icons.archive_rounded),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('fest',
                isEqualTo:
                    mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2])
            .orderBy('date')
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                if (snapshot.data!.docs[ind]['archive']) {
                  return SizedBox();
                }
                return SwipeableTile.swipeToTrigger(
                  color: Colors.transparent,
                  key: Key(snapshot.data!.docs[ind]['link']),
                  backgroundBuilder: (context, direction, progress) {
                    return Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.delete),
                          Icon(Icons.delete),
                        ],
                      ),
                    );
                  },
                  onSwiped: (direction) async {
                    var temp = new DateTime.fromMicrosecondsSinceEpoch(snapshot
                        .data!.docs[ind]['date'].microsecondsSinceEpoch);
                    if (!temp.isBefore(DateTime.now())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Event is yet to happen so cannot archive it."),
                        ),
                      );
                      return;
                    } else {
                      int curr = ind;
                      await snapshot.data!.docs[ind].reference
                          .update({'archive': true});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Event successfully archived."),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () async {
                              await snapshot.data!.docs[curr].reference
                                  .update({'archive': false});
                            },
                          ),
                        ),
                      );
                    }
                  },
                  direction: SwipeDirection.horizontal,
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return EditEventScreen(
                            docID: snapshot.data!.docs[ind].id,
                            fest: snapshot.data!.docs[ind]['fest'],
                            title: snapshot.data!.docs[ind]['title'],
                          );
                        }));
                      },
                      title: Text(snapshot.data!.docs[ind]['title']),
                      trailing: snapshot.data!.docs[ind]['register']
                          ? ElevatedButton(
                              onPressed: () {
                                if (snapshot.data!.docs[ind]['teamSize'] == 1) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return IndividualRegistrationScreen(
                                      docID: snapshot.data!.docs[ind].id,
                                    );
                                  }));
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return TeamRegistrationScreen(
                                        docID: snapshot.data!.docs[ind].id,
                                        size: snapshot.data!.docs[ind]
                                            ['teamSize']);
                                  }));
                                }
                              },
                              child: Text("See registrations"),
                            )
                          : null,
                    ),
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
