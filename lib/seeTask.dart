import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/archiveTask.dart';
import 'package:festapp/func.dart';
import 'package:festapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ArchiveTaskScreen();
              }));
            },
            icon: Icon(CupertinoIcons.archivebox_fill),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String title = "", desc = "";
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            context: context,
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Title",
                      ),
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                      ),
                      onChanged: (value) {
                        setState(() {
                          desc = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance.collection('tasks').add({
                        'title': title,
                        'desc': desc,
                        'author': mainUser.name,
                        'fest': mainUser.fest,
                        'resolver': "",
                        'roll': "",
                        'solved': false,
                        'time': Timestamp.now(),
                      });
                      sendTaskNotif(title, desc, mainUser.fest);
                      Navigator.pop(context);
                    },
                    child: Text("Upload Task"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, ind) {
                if (snapshot.data!.docs[ind]['fest'] != mainUser.fest) {
                  return SizedBox();
                } else if (snapshot.data!.docs[ind]['solved']) {
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
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await snapshot.data!.docs[ind].reference.update({
                            'solved': true,
                            'resolver': mainUser.name,
                            'roll': mainUser.roll,
                            'doneAt': Timestamp.now(),
                          });
                        },
                        child: Text("Mark as Done"),
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
