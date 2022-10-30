import 'package:festapp/func.dart';
import 'package:flutter/material.dart';

class SendNotifScreen extends StatefulWidget {
  const SendNotifScreen({Key? key}) : super(key: key);

  @override
  State<SendNotifScreen> createState() => _SendNotifScreenState();
}

class _SendNotifScreenState extends State<SendNotifScreen> {
  String title = "", info = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Screen"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: TextStyle(color: Colors.black),
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                hintText: "Info",
              ),
              onChanged: (value) {
                setState(() {
                  info = value;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await sendNotif(title, info);
            },
            child: Text("Send Notification"),
          ),
        ],
      ),
    );
  }
}
