import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(
                          "Are you sure you want to delete all the orders which have been delivered? Please make sure there are no orders wrongly marked delivered."),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .where('email', isEqualTo: mainUser.email)
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              for (var documentSnapshot in querySnapshot.docs) {
                                if (documentSnapshot['delivered']) {
                                  documentSnapshot.reference.delete();
                                }
                              }
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
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('roll', isEqualTo: mainUser.roll)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                return Card(
                  color: snapshot.data!.docs[ind]['delivered']
                      ? Colors.green
                      : Colors.grey,
                  child: ListTile(
                    title: Text(snapshot.data!.docs[ind]['merchName']),
                    subtitle: Text(snapshot.data!.docs[ind]['fest']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Color: ${snapshot.data!.docs[ind]['color']}"),
                        Text("Size: ${snapshot.data!.docs[ind]['size']}"),
                        if (snapshot.data!.docs[ind]['delivered'])
                          Text("Delivered")
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
