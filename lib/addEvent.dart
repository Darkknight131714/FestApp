import 'dart:io';

import 'package:festapp/func.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String link = "", title = "", desc = "", venue = "";
  TextEditingController timeinput = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  DateTime? selec = DateTime.now();
  TimeOfDay? time = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
        actions: [
          IconButton(
              onPressed: () async {
                if (link == "" || title == "" || desc == "" || venue == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "All Fields are compulsory. Please enter all the details."),
                    ),
                  );
                } else {
                  await uploadEvent(
                      title, desc, venue, link, selec, timeinput.text);
                  await sendNotif(
                      "NEW EVENT!!!😎", title + " is the new Event added.");
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Event Title",
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
                keyboardType: TextInputType.name,
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Venue",
                ),
                onChanged: (value) {
                  setState(() {
                    venue = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: timeinput, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.timer), //icon of text field
                    labelText: "Enter Time" //label text of field
                    ),
                readOnly: true,
                onTap: () async {
                  time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (time != null) {
                    DateTime parsedTime =
                        DateFormat.jm().parse(time!.format(context).toString());
                    String formattedTime =
                        DateFormat('h:mma').format(parsedTime);

                    setState(() {
                      timeinput.text = formattedTime;
                    });
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: dateinput, //editing controller of this TextField
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month), //icon of text field
                    labelText: "Enter Date" //label text of field
                    ),
                readOnly:
                    true, //set it true, so that user will not able to edit text
                onTap: () async {
                  selec = await showDatePicker(
                      context: context,
                      initialDate: selec!,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030));

                  if (selec != null) {
                    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                    var inputDate = inputFormat.parse(selec.toString());
                    var outputFormat = DateFormat('dd/MM/yyyy');
                    setState(() {
                      dateinput.text = outputFormat.format(inputDate);
                    });
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  String down = await upload(File(image.path));
                  setState(() {
                    link = down;
                  });
                }
              },
              icon: Icon(Icons.add_a_photo),
            ),
            if (link != "") Image.network(link)
          ],
        ),
      ),
    );
  }
}
