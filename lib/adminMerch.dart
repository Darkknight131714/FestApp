import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminMerchScreen extends StatefulWidget {
  const AdminMerchScreen({Key? key}) : super(key: key);

  @override
  State<AdminMerchScreen> createState() => _AdminMerchScreenState();
}

class _AdminMerchScreenState extends State<AdminMerchScreen> {
  var m = {
    true: "Unavailable",
    false: "Available",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Merch"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(mainUser.fest)
            .doc('merch')
            .collection('merch')
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                return Card(
                  color: snapshot.data!.docs[ind]['available']
                      ? Colors.green
                      : Colors.red,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(snapshot.data!.docs[ind]['name']),
                        subtitle: Text(snapshot.data!.docs[ind]['price']),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            snapshot.data!.docs[ind]['available']
                                ? SizedBox()
                                : ElevatedButton(
                                    onPressed: () async {
                                      bool cond = true;
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .where('fest',
                                              isEqualTo: mainUser.fest)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        for (var documentSnapshot
                                            in querySnapshot.docs) {
                                          if (documentSnapshot['merchName'] ==
                                              snapshot.data!.docs[ind]
                                                  ['name']) {
                                            cond = cond &
                                                documentSnapshot['delivered'];
                                          }
                                        }
                                        if (cond) {
                                          List<String> url = [];
                                          int len = snapshot
                                              .data!.docs[ind]['links'].length;
                                          for (int i = 0; i < len; i++) {
                                            url.add(snapshot
                                                .data!.docs[ind]['links'][i]
                                                .toString());
                                          }
                                          snapshot.data!.docs[ind].reference
                                              .delete();
                                          for (int i = 0; i < url.length; i++) {
                                            FirebaseStorage.instance
                                                .refFromURL(url[i])
                                                .delete();
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Merch Deleted Succesfully"),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "All orders for this merch have not been delivered. So merch has not been deleted."),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: Text("Delete This Merch"),
                                  ),
                            ElevatedButton(
                              onPressed: () async {
                                bool flag =
                                    !snapshot.data!.docs[ind]['available'];
                                await snapshot.data!.docs[ind].reference
                                    .update({'available': flag});
                              },
                              child: Text(
                                  "Make merch ${m[snapshot.data!.docs[ind]['available']]}"),
                            ),
                          ],
                        ),
                      ),
                    ],
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
