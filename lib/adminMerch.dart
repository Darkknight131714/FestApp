import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

class AdminMerchScreen extends StatefulWidget {
  const AdminMerchScreen({Key? key}) : super(key: key);

  @override
  State<AdminMerchScreen> createState() => _AdminMerchScreenState();
}

class _AdminMerchScreenState extends State<AdminMerchScreen> {
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
                  child: ListTile(
                    tileColor: snapshot.data!.docs[ind]['available']
                        ? Colors.green
                        : Colors.red,
                    title: Text(snapshot.data!.docs[ind]['name']),
                    subtitle: Text(snapshot.data!.docs[ind]['price']),
                    trailing: IconButton(
                      icon: Icon(Icons.swap_horiz_outlined),
                      onPressed: () async {
                        bool flag = !snapshot.data!.docs[ind]['available'];
                        await snapshot.data!.docs[ind].reference
                            .update({'available': flag});
                      },
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
