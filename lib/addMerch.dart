import 'dart:io';

import 'package:festapp/func.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:card_swiper/card_swiper.dart';

class addMerchScreen extends StatefulWidget {
  const addMerchScreen({Key? key}) : super(key: key);

  @override
  State<addMerchScreen> createState() => _addMerchScreenState();
}

class _addMerchScreenState extends State<addMerchScreen> {
  List<String> links = [];
  String name = "", price = "";
  List<String> colors = [];
  String color = "";
  TextEditingController contr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Merch"),
        actions: [
          IconButton(
              onPressed: () async {
                if (colors.length == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("There should be atleast 1 color"),
                    ),
                  );
                } else if (links.length == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("There should be atleast 1 Image"),
                    ),
                  );
                } else if (name == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please Enter Merch Name"),
                    ),
                  );
                } else if (price == "") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please Enter Merch Price"),
                    ),
                  );
                } else {
                  await addMerch(
                      mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2],
                      name,
                      price,
                      colors,
                      links);
                  await showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("Merch Added"),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Exit"),
                            ),
                          ],
                        );
                      });
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
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
                    hintText: "Name",
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Price",
                  ),
                  onChanged: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: contr,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Add Color",
                  ),
                  onChanged: (value) {
                    setState(() {
                      color = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (color != "") {
                    colors.add(color);
                  }
                  setState(() {
                    color = "";
                    contr.clear();
                  });
                },
                child: Text("Add Color"),
              ),
              Text("Colors Added"),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (_, ind) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(colors[ind]),
                    );
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
                      links.add(down);
                    });
                  }
                },
                icon: Icon(Icons.add_a_photo),
              ),
              Expanded(
                child: Swiper(
                  containerWidth: double.infinity,
                  itemWidth: double.infinity,
                  itemCount: links.length,
                  pagination: SwiperPagination(),
                  itemBuilder: (_, ind) {
                    return Image.network(
                      links[ind],
                      width: double.infinity,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
