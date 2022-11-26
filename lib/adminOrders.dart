import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:festapp/removeOrder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  String fest = mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2];
  String searchValue = "";
  List<String> suggestions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillSuggestions();
  }

  Future<void> fillSuggestions() async {
    await FirebaseFirestore.instance
        .collection('orders')
        .where('fest', isEqualTo: fest)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot['delivered'] == false) {
          suggestions.add(documentSnapshot['name']);
        }
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: EasySearchBar(
              title: Text("All Orders"),
              onSearch: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              suggestions: suggestions,
              onSuggestionTap: (val) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return RemoveOrderScreen(name: val);
                  }),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('fest', isEqualTo: fest)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasData == false) {
                return CircularProgressIndicator();
              } else {
                return Flexible(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, ind) {
                      if (snapshot.data!.docs[ind]['delivered']) {
                        return SizedBox();
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[ind]['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data!.docs[ind]['roll']),
                                      Divider(),
                                      Text(snapshot.data!.docs[ind]
                                              ['merchName'] +
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
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
