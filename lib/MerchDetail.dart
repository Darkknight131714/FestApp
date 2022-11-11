import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:festapp/func.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

late Razorpay _razorpay;

class MerchDetail extends StatefulWidget {
  DocumentSnapshot doc;
  String fest;
  MerchDetail({required this.doc, required this.fest});

  @override
  State<MerchDetail> createState() => _MerchDetailState();
}

class _MerchDetailState extends State<MerchDetail> {
  String? color = "";
  String def = "";
  String def1 = "";
  List<String> sizes = ["S", "M", "L", "XL"];
  String? size = "S";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    color = widget.doc['colors'][0];
    def = color!;
    def1 = sizes[0];
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String id = response.paymentId.toString();
    addOrder(widget.fest, widget.doc['name'], id, color!, size!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Success"),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "ERROR: " + response.code.toString() + " - " + response.message!),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "EXTERNAL WALLET: " + response.walletName!,
        ),
      ),
    );
  }

  void openCheckout(
      int price, String name, String fest, String color, String size) async {
    price = price * 100;
    var options = {
      'key': 'rzp_test_o4eo3gVWbgAyru',
      'amount': price,
      'name': name,
      'description': name + " " + color + " " + size,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc['name']),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Column(
            children: [
              SizedBox(
                width: 500,
                height: 400,
                child: Swiper(
                  itemCount: widget.doc['links'].length,
                  pagination: SwiperPagination(),
                  itemBuilder: (_, ind) {
                    return Image.network(
                      widget.doc['links'][ind],
                      fit: BoxFit.fitWidth,
                    );
                  },
                ),
              ),
              Text("Price: ${widget.doc['price']}"),
              Divider(
                color: Colors.orange,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Select your Color"),
              CustomRadioButton(
                horizontal: false,
                enableShape: true,
                unSelectedColor: Colors.grey,
                buttonLables: widget.doc['colors'].map<String>((val) {
                  return val.toString();
                }).toList(),
                buttonValues: widget.doc['colors'].map<String>((val) {
                  return val.toString();
                }).toList(),
                defaultSelected: def,
                radioButtonValue: (value) {
                  setState(() {
                    color = value.toString();
                  });
                },
                selectedColor: Theme.of(context).accentColor,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Select your Color"),
              CustomRadioButton(
                horizontal: false,
                enableShape: true,
                unSelectedColor: Colors.grey,
                buttonLables: sizes,
                buttonValues: sizes,
                defaultSelected: def1,
                radioButtonValue: (value) {
                  setState(() {
                    size = value.toString();
                  });
                },
                selectedColor: Theme.of(context).accentColor,
              ),
              SizedBox(
                height: 10,
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
                onPressed: () async {
                  openCheckout(int.parse(widget.doc['price']),
                      widget.doc['name'], widget.fest, color!, size!);
                },
                child: Text("Buy"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
