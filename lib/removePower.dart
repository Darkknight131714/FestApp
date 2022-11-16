import 'package:festapp/festMerch.dart';
import 'package:festapp/showMembers.dart';
import 'package:festapp/viewTeam.dart';
import 'package:flutter/material.dart';

class RemovePower extends StatefulWidget {
  const RemovePower({Key? key}) : super(key: key);

  @override
  State<RemovePower> createState() => _BuyMerchState();
}

class _BuyMerchState extends State<RemovePower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Fest"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ShowMembers(fest: 'apk');
                    },
                  ),
                );
              },
              title: Text("Aparoksha"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ShowMembers(fest: 'efe');
                    },
                  ),
                );
              },
              title: Text("Effervesence"),
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ShowMembers(fest: 'asm');
                    },
                  ),
                );
              },
              title: Text("Asmita"),
            ),
          ),
        ],
      ),
    );
  }
}
