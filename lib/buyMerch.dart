import 'package:festapp/festMerch.dart';
import 'package:festapp/viewTeam.dart';
import 'package:flutter/material.dart';

class BuyMerch extends StatefulWidget {
  const BuyMerch({Key? key}) : super(key: key);

  @override
  State<BuyMerch> createState() => _BuyMerchState();
}

class _BuyMerchState extends State<BuyMerch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy Merch"),
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
                      return MerchScreen(fest: 'apk');
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
                      return MerchScreen(fest: 'efe');
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
                      return MerchScreen(fest: 'asm');
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
