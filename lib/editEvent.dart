import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEventScreen extends StatefulWidget {
  String docID;
  String fest;
  String title;
  EditEventScreen(
      {required this.docID, required this.fest, required this.title});

  @override
  State<EditEventScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EditEventScreen> {
  String date = "";
  String deadline = "";
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Text(
            widget.fest.toUpperCase(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
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
                if (snapshot.data!['register']) {
                  temp = new DateTime.fromMicrosecondsSinceEpoch(
                      snapshot.data!['deadline'].microsecondsSinceEpoch);
                  inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                  inputDate = inputFormat.parse(temp.toString());
                  outputFormat = DateFormat('dd/MM/yyyy');
                  deadline = outputFormat.format(inputDate);
                }
                return Column(
                  children: [
                    SizedBox(width: double.infinity),
                    Image.network(
                      snapshot.data!['link'],
                      height: MediaQuery.of(context).size.height / 2,
                    ),
                    Text(
                      "Description: ${snapshot.data!['desc']}",
                      style: TextStyle(fontSize: 25),
                    ),
                    Divider(
                      color: Colors.orange,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Date: ${date}",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () async {
                            DateTime? selec = DateTime.now();
                            selec = await showDatePicker(
                                context: context,
                                initialDate: selec!,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2030));
                            if (selec != null) {
                              await snapshot.data!.reference.update({
                                'date': selec,
                              });
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Time: ${snapshot.data!['time']}",
                          style: TextStyle(fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () async {
                            TimeOfDay? time;
                            time = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (time != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(time.format(context).toString());
                              String formattedTime =
                                  DateFormat('h:mma').format(parsedTime);
                              await snapshot.data!.reference.update({
                                'time': formattedTime,
                              });
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    Text(
                      "Venue: ${snapshot.data!['venue']}",
                      style: TextStyle(fontSize: 20),
                    ),
                    if (snapshot.data!['register'])
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Deadline: ${deadline}",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () async {
                              DateTime? selec = DateTime.now();
                              selec = await showDatePicker(
                                  context: context,
                                  initialDate: selec!,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2030));
                              if (selec != null) {
                                await snapshot.data!.reference.update({
                                  'deadline': selec,
                                });
                              }
                            },
                            icon: Icon(Icons.edit),
                          ),
                        ],
                      ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
