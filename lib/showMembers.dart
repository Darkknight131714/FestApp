import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ShowMembers extends StatefulWidget {
  String fest;
  ShowMembers({required this.fest});

  @override
  State<ShowMembers> createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ShowMembers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fest + " Team"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, ind) {
                  if (snapshot.data!.docs[ind]['fest'] != widget.fest) {
                    return SizedBox();
                  } else {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[ind]['name']),
                        subtitle: Text(snapshot.data!.docs[ind]['roll']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await snapshot.data!.docs[ind].reference
                                .update({'fest': ""});
                          },
                        ),
                      ),
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
