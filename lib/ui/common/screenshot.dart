import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import '../../common/colors.dart';
import '../../common/converter.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/widgets.dart';
import 'package:share/share.dart';

class ScreenShot extends StatefulWidget {
  final appointmentDatetime,
      reqDate,
      reachedTime,
      completeTime,
      address,
      serviceName,
      amount,
      name,
      spName,
      particular,
      billId;

  ScreenShot({
    Key? key,
    required this.appointmentDatetime,
    required this.reqDate,
    required this.reachedTime,
    required this.completeTime,
    required this.address,
    required this.serviceName,
    required this.amount,
    required this.name,
    required this.spName,
    required this.particular,
    required this.billId,
  }) : super(key: key);

  @override
  _ScreenShotState createState() => _ScreenShotState();
}

class _ScreenShotState extends State<ScreenShot> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    save();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.bgColor,
      child: Center(
        child: Screenshot(
          controller: screenshotController,
          child: Card(
            color: MyColors.bgColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: MyColors.themeColor),
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Invoice No : ${widget.billId.toString().padLeft(4, '0')}\nBill For : ${widget.serviceName}\nBill To : ${widget.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Widgets.sizedBox(10, 0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Requested Date & Time',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.reqDate}'.toString().toDateTime(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Appointment Date & Time',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.appointmentDatetime}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Reached Time',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.reachedTime}'.toString().toDateTime(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Complete Time',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.completeTime.toString().toDateTime()}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Address',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.address}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Service Name',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.serviceName}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '₹ ${widget.amount}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Particular',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.particular}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.normalTextColor),
                            ),
                          ),
                        ],
                      ),
                      Widgets.divider(),
                      Widgets.sizedBox(10, 0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Bill From : ' + widget.spName,
                          style: TextStyle(
                            color: MyColors.dividerColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Widgets.sizedBox(10, 0),
                      Row(
                        children: [
                          Icon(
                            MyIcons.point,
                            color: MyColors.dividerColor,
                            size: 16,
                          ),
                          Widgets.sizedBox(0, 10),
                          Expanded(
                              child: Text(
                            "This is Electronic Generated Invoice doesn't required any signature.",
                            style: TextStyle(
                              color: MyColors.dividerColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    final directory = (await getExternalStorageDirectory())!.path;
    String fileName = DateTime.now().toIso8601String();
    var path = '$directory/$fileName.png';
    screenshotController.captureAndSave(path).then((value) async {
      await Share.shareFiles(['$value']);
      Fun.goBack(context);
    });
  }
}
