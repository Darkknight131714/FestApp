import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/MerchDetail.dart';
import 'package:festapp/viewTeam.dart';
import 'package:flutter/material.dart';

class MerchScreen extends StatefulWidget {
  String fest;
  MerchScreen({required this.fest});

  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Merch"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ViewTeam(fest: widget.fest);
              }));
            },
            child: Text("View Team"),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(widget.fest)
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
                if (snapshot.data!.docs[ind]['available'] == false) {
                  return SizedBox();
                } else {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return MerchDetail(
                            doc: snapshot.data!.docs[ind],
                            fest: widget.fest,
                          );
                        }));
                      },
                      title: Text(snapshot.data!.docs[ind]['name']),
                      subtitle:
                          Text("Price: ₹${snapshot.data!.docs[ind]['price']}"),
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
