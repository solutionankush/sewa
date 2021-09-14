import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sewa/backend_work/getting_data.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/common/converter.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/common/icons.dart';
import 'package:sewa/common/styles.dart';
import 'package:sewa/common/variables.dart' as Variables;
import 'package:sewa/common/widgets.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class PaymentDetail extends StatefulWidget {
  final billId;

  const PaymentDetail({Key? key, this.billId}) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  ScreenshotController screenshotController = ScreenshotController();
  var data, paymentMode;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var res = await GettingData.getPaymentDetail(widget.billId);
    setState(() {
      data = res;
      if (data != null) {
        if (data[0]['PAYMENTMODE'] == 'CC') {
          paymentMode = "Credit Card";
        } else if (data[0]['PAYMENTMODE'] == 'DC') {
          paymentMode = "Debit Card";
        } else if (data[0]['PAYMENTMODE'] == 'NB') {
          paymentMode = "Net Banking";
        } else if (data[0]['PAYMENTMODE'] == 'PPI') {
          paymentMode = "Paytm Wallet";
        } else if (data[0]['PAYMENTMODE'] == 'PAYTMCC') {
          paymentMode = "Postpaid";
        } else {
          paymentMode = "CASE";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = WillPopScope(
      child: SingleChildScrollView(
        child: data != null
            ? Column(
                children: [
                  if (data[0]['STATUS'] == 'TXN_SUCCESS') ...[
                    Screenshot(
                      child: ClipPath(
                        clipper: MultipleRoundedCurveClipper(),
                        child: Container(
                          color: MyColors.bgColor,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Center(
                                child: UnDraw(
                                  color: MyColors.goodColor,
                                  height: 35.h,
                                  illustration:
                                      UnDrawIllustration.order_confirmed,
                                  errorWidget: Icon(Icons.error_outline,
                                      color: Colors.red,
                                      size:
                                          30), //optional, default is the Text('Could not load illustration!').
                                ),
                              ),
                              Widgets.sizedBox(5, 0),
                              Text(
                                "PAYMENT SUCCESSFUL",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyColors.goodColor,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Widgets.sizedBox(10, 0),
                              Text(
                                "Transaction Id",
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              Text(
                                "${data[0]['TXNID']}",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              Widgets.sizedBox(10, 0),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Service Name:",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${data[0]['service_name']}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Request Id:",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${data[0]['req_id'].toString().padLeft(4, '0')}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Order Id :",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${data[0]['ORDERID']}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Amount :",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "₹ ${data[0]['TXNAMOUNT']}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Payment Date :",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${data[0]['TXNDATE'].toString().toDateTime()}",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Payment Mode :",
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "$paymentMode",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                              if (paymentMode != 'CASE') ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Bank :",
                                        style: TextStyle(fontSize: 16.sp),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${data[0]['BANKNAME']}",
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      controller: screenshotController,
                    ),
                    Widgets.sizedBox(1.h, 0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                Styles.roundButtonShape()),
                            backgroundColor:
                                MaterialStateProperty.all(MyColors.goodColor),
                          ),
                          onPressed: () {
                            Fun.oneWayRouter(context, Variables.Links.home);
                          },
                          label: Text('Get More Sewa'),
                          icon: Icon(
                            MyIcons.home,
                            size: 4.w,
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                Styles.roundButtonShape()),
                            backgroundColor: MaterialStateProperty.all(
                                MyColors.highlightColor),
                          ),
                          onPressed: () async {
                            final directory =
                                (await getExternalStorageDirectory())!.path;
                            String fileName = DateTime.now().toIso8601String();
                            var path = '$directory/$fileName.png';
                            screenshotController
                                .captureAndSave(path)
                                .then((value) async {
                              await Share.shareFiles(['$value']);
                            });
                          },
                          label: Text('Share Receipt'),
                          icon: Icon(
                            MyIcons.share,
                            size: 4.w,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Center(
                      child: UnDraw(
                        color: MyColors.badColor!,
                        height: 40.h,
                        illustration: UnDrawIllustration.access_denied,
                        errorWidget: Icon(Icons.error_outline,
                            color: Colors.red,
                            size:
                                50), //optional, default is the Text('Could not load illustration!').
                      ),
                    ),
                    Widgets.sizedBox(5.h, 0),
                    Text(
                      "Payment Failed \nPlease try again or Pay Case",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: MyColors.badColor, fontSize: 18.sp),
                    ),
                    Widgets.sizedBox(5.h, 0),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            Styles.roundButtonShape()),
                        backgroundColor:
                            MaterialStateProperty.all(MyColors.badColor),
                      ),
                      onPressed: () {
                        Fun.oneWayRouter(context, Variables.Links.myBills);
                      },
                      label: Text('Go Back to pay again'),
                      icon: Icon(
                        MyIcons.back,
                        size: 4.w,
                      ),
                    ),
                  ],
                ],
              )
            : Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: MyColors.highlightColor,
                  )),
                ),
              ),
      ),
      onWillPop: () => Fun.oneWayRouter(context, Variables.Links.home),
    );
    return Widgets.scaffoldWithoutAppBar(body, context);
  }
}
