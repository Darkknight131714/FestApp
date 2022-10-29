import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/main.dart';
import 'package:festapp/registerTeam.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterEventDetailScreen extends StatefulWidget {
  String docID;
  RegisterEventDetailScreen({required this.docID});

  @override
  State<RegisterEventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<RegisterEventDetailScreen> {
  String date = "";
  String deadlineDate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registerable Event Detail"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docID)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          } else {
            var temp = new DateTime.fromMicrosecondsSinceEpoch(
                snapshot.data!['date'].microsecondsSinceEpoch);
            var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
            var inputDate = inputFormat.parse(temp.toString());
            var outputFormat = DateFormat('dd/MM/yyyy');
            date = outputFormat.format(inputDate);
            temp = new DateTime.fromMicrosecondsSinceEpoch(
                snapshot.data!['deadline'].microsecondsSinceEpoch);
            inputFormat = DateFormat('yyyy-MM-dd HH:mm');
            inputDate = inputFormat.parse(temp.toString());
            outputFormat = DateFormat('dd/MM/yyyy');
            deadlineDate = outputFormat.format(inputDate);
            return Column(
              children: [
                SizedBox(width: double.infinity),
                Image.network(
                  snapshot.data!['link'],
                  height: MediaQuery.of(context).size.height / 2,
                ),
                Text("Fest: ${snapshot.data!['fest']}"),
                Text("Title: ${snapshot.data!['title']}"),
                Text("Description: ${snapshot.data!['desc']}"),
                Text("Date: ${date}"),
                Text("Time: ${snapshot.data!['time']}"),
                Text("Venue: ${snapshot.data!['venue']}"),
                Text("Team Size: ${snapshot.data!['teamSize']}"),
                Text("Deadline: ${deadlineDate}"),
                ElevatedButton(
                  onPressed: () {
                    if (snapshot.data!['teamSize'] == 1) {
                      if (snapshot.data!['emails'].contains(mainUser.email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User has already registered"),
                          ),
                        );
                      } else {
                        List<dynamic> regis = snapshot.data!['registrations'];
                        regis.add(mainUser.mobile);
                        regis.add(mainUser.name);
                        regis.add(mainUser.email);
                        snapshot.data!.reference.update({
                          'emails': FieldValue.arrayUnion([mainUser.email]),
                          'registrations': regis,
                        });
                        FirebaseFirestore.instance
                            .collection('registrations')
                            .add({
                          'email': mainUser.email,
                          'docID': widget.docID,
                          'time': snapshot.data!['date'],
                          'title': snapshot.data!['title'],
                          'desc': snapshot.data!['desc'],
                          'venue': snapshot.data!['venue'],
                          'link': snapshot.data!['link'],
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("User Registered Successfully"),
                          ),
                        );
                      }
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return TeamRegisterScreen(
                            docID: widget.docID,
                            size: snapshot.data!['teamSize']);
                      }));
                    }
                  },
                  child: Text("Register"),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
