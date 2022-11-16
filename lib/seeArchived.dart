import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/editEvent.dart';
import 'package:festapp/individualRegistration.dart';
import 'package:festapp/main.dart';
import 'package:festapp/registerTeam.dart';
import 'package:festapp/teamRegistration.dart';
import 'package:flutter/material.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class SeeArchived extends StatefulWidget {
  const SeeArchived({Key? key}) : super(key: key);

  @override
  State<SeeArchived> createState() => _AdminEventScreenState();
}

class _AdminEventScreenState extends State<SeeArchived> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("See Archived Events"),
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
                if (!snapshot.data!.docs[ind]['archive']) {
                  return SizedBox();
                }
                return Card(
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
