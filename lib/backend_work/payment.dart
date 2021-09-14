import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/ui/user/payment_detail.dart';

import '../common/variables.dart' as Variables;

class PaymentScreen extends StatefulWidget {
  final amount, billId;

  const PaymentScreen({Key? key, this.amount, this.billId}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var custId = Variables.userUId;

  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  late StreamSubscription<String> _onUrlChanged;

  String? status;


  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    // Add a listener to on url changed
    flutterWebviewPlugin.onBack.listen((event) {
      Navigator.pop(context);
    });
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('response.php')) {
        flutterWebviewPlugin.close();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentDetail(billId: widget.billId,),),);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebviewScaffold(
        url:
            "${Api.payment}?bill_id=${widget.billId}&cust_id=$custId&amount=${widget.amount}",
      ),
    );
  }
}
