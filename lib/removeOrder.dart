import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.docs[ind]['name'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(snapshot.data!.docs[ind]['roll']),
                                Divider(),
                                Text(snapshot.data!.docs[ind]['merchName'] +
                                    " (" +
                                    snapshot.data!.docs[ind]['color'] +
                                    ")"),
                                Row(
                                  children: [
                                    Text("Size: "),
                                    Text(
                                      snapshot.data!.docs[ind]['size'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            // Text(snapshot.data!.docs[ind]['merchName']),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     Text("Size: ${snapshot.data!.docs[ind]['size']}"),
                            //     Text(snapshot.data!.docs[ind]['color']),
                            //   ],
                            // ),
                            IconButton(
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber(
                                    snapshot.data!.docs[ind]['phone']);
                              },
                              icon: Icon(
                                CupertinoIcons.phone_circle_fill,
                                color: Colors.green,
                                size: 50,
                              ),
                            ),
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
