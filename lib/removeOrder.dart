import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class RemoveOrderScreen extends StatefulWidget {
  String name;
  RemoveOrderScreen({required this.name});

  @override
  State<RemoveOrderScreen> createState() => _RemoveOrderScreenState();
}

class _RemoveOrderScreenState extends State<RemoveOrderScreen> {
  String fest = mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('fest', isEqualTo: fest)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                if (snapshot.data!.docs[ind]['name'] != widget.name) {
                  return SizedBox();
                }
                if (snapshot.data!.docs[ind]['delivered']) {
                  return SizedBox();
                }
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(snapshot.data!.docs[ind]['name']),
                            Text(snapshot.data!.docs[ind]['roll']),
                          ],
                        ),
                        Text(snapshot.data!.docs[ind]['merchName']),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Size: ${snapshot.data!.docs[ind]['size']}"),
                            Text(snapshot.data!.docs[ind]['color']),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                        "Are you sure you want to mark this as delivered?"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          await snapshot
                                              .data!.docs[ind].reference
                                              .update({
                                            'delivered': true,
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text("Mark as Delivered"),
                        ),
                      ],
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
