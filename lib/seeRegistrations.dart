import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/anotherEventDetail.dart';
import 'package:festapp/detailEvent.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

class SeeRegistrationScreen extends StatefulWidget {
  const SeeRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<SeeRegistrationScreen> createState() => _SeeRegistrationScreenState();
}

class _SeeRegistrationScreenState extends State<SeeRegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("See your Registrations"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('registrations')
              .where('email', isEqualTo: mainUser.email)
              .orderBy('time')
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData == false) {
              return CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, ind) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return AnotherEventDetailScreen(
                              docID: snapshot.data!.docs[ind]['docID']);
                        }));
                      },
                      title: Text(snapshot.data!.docs[ind]['title']),
                      subtitle: Text(snapshot.data!.docs[ind]['desc']),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
