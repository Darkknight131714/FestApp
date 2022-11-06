import 'package:festapp/festMerch.dart';
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              minimumSize: Size(120, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return MerchScreen(fest: 'apk');
                  },
                ),
              );
            },
            child: Text("APK"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              minimumSize: Size(120, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return MerchScreen(fest: 'efe');
                  },
                ),
              );
            },
            child: Text("Effe"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              minimumSize: Size(120, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return MerchScreen(fest: 'asm');
                  },
                ),
              );
            },
            child: Text("Asmita"),
          ),
        ],
      ),
    );
  }
}
