import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

class ArchiveTaskScreen extends StatefulWidget {
  const ArchiveTaskScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveTaskScreen> createState() => _ArchiveTaskScreenState();
}

class _ArchiveTaskScreenState extends State<ArchiveTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Done Tasks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('doneAt', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                if (snapshot.data!.docs[ind]['solved'] == false) {
                  return SizedBox();
                } else if (snapshot.data!.docs[ind]['fest'] != mainUser.fest) {
                  return SizedBox();
                } else {
                  return Card(
                    child: ListTile(
                      title:
                          Text("Title: " + snapshot.data!.docs[ind]['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            color: Colors.orange,
                          ),
                          Text(snapshot.data!.docs[ind]['desc']),
                          Text("Uploaded by " +
                              snapshot.data!.docs[ind]['author']),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Done by: " +
                              snapshot.data!.docs[ind]['resolver']),
                          Text("Roll: " + snapshot.data!.docs[ind]['roll']),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
