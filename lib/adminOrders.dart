import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:festapp/removeOrder.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.black12,
        automaticallyImplyLeading: false,
        title: SizedBox(
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
