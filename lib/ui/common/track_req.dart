import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sewa/backend_work/getting_data.dart';
import 'package:sewa/backend_work/update_data.dart';
import 'package:sewa/common/converter.dart';
import 'package:sewa/common/icons.dart';
import 'package:sewa/common/styles.dart';
import 'package:sewa/common/widgets.dart';
import 'package:sewa/ui/sp/bill_generate.dart';
import 'package:sewa/ui/user/bill.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../common/colors.dart';

class TrackReq extends StatefulWidget {
  final appointmentDatetime,
      reqDate,
      isUser,
      mob,
      serviceName,
      name,
      spName,
      remark,
      address,
      reqId;

  TrackReq({
    Key? key,
    required this.appointmentDatetime,
    required this.reqDate,
    required this.isUser,
    required this.mob,
    required this.serviceName,
    required this.name,
    required this.spName,
    required this.remark,
    required this.address,
    required this.reqId,
  }) : super(key: key);

  @override
  _TrackReqState createState() => _TrackReqState();
}

class _TrackReqState extends State<TrackReq> {
  ScreenshotController screenshotController = ScreenshotController();

  var _status = [
    'Pending',
  ];
  var billId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      status();
    });
  }

  status() async {
    var current = await GettingData.currentStatus(widget.reqId);
    var data = current[0];
    var _cStatus = data['status'];
    var id = data['id'];

    if (!_status.contains(_cStatus)) {
      if (_cStatus == 'On the Way') {
        if (!_status.contains('Approved')) {
          _status.add('Approved');
        }
      }
      if (_cStatus == 'Reached') {
        if (!_status.contains('Approved')) {
          _status.add('Approved');
        }
        if (!_status.contains('On the Way')) {
          _status.add('On the Way');
        }
      }
      if (_cStatus == 'Complete') {
        if (!_status.contains('Approved')) {
          _status.add('Approved');
        }
        if (!_status.contains('On the Way')) {
          _status.add('On the Way');
        }
        if (!_status.contains('Reached')) {
          _status.add('Reached');
        }
      }
      if (_cStatus == 'Bill Generated') {
        if (!_status.contains('Approved')) {
          _status.add('Approved');
        }
        if (!_status.contains('On the Way')) {
          _status.add('On the Way');
        }
        if (!_status.contains('Reached')) {
          _status.add('Reached');
        }
        if (!_status.contains('Complete')) {
          _status.add('Complete');
        }
        billId = id;
      }
      if (_cStatus == 'Paid') {
        if (!_status.contains('Approved')) {
          _status.add('Approved');
        }
        if (!_status.contains('On the Way')) {
          _status.add('On the Way');
        }
        if (!_status.contains('Reached')) {
          _status.add('Reached');
        }
        if (!_status.contains('Complete')) {
          _status.add('Complete');
        }
        if (!_status.contains('Bill Generated')) {
          _status.add('Bill Generated');
        }
        billId = id;
      }
      _status.add(_cStatus);
    }
    isLoading = false;
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 50),
          child: isLoading
              ? Column(
                  children: [Widgets.sizedBox(40.h, 0), Widgets.loading()],
                )
              : Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: MyColors.bgColor,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Booking ID",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "#${widget.reqId.toString().padLeft(4, '0')}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  Text(
                                    "Current Status",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${_status[_status.length - 1]}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  Text(
                                    "Solution for",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${widget.serviceName}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  Text(
                                    "Remark",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${widget.remark}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Request Time",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${widget.reqDate.toString().toDateTime()}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  Text(
                                    "Appointment Time",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${widget.appointmentDatetime}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  Text(
                                    "${widget.isUser ? "Vendor" : "User"} Name",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Text(
                                    "${widget.isUser ? widget.spName : widget.name}",
                                    style: TextStyle(
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                  Widgets.sizedBox(15, 0),
                                  TextButton.icon(
                                    onPressed: () {
                                      save();
                                    },
                                    icon: Icon(MyIcons.share),
                                    label: Text('Share'),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Widgets.sizedBox(5, 0),
                          Text(
                            "User Address",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                          ),
                          Text(
                            "${widget.address}".replaceAll('\n', ' '),
                            style: TextStyle(
                                color: MyColors.highlightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                          ),
                          Widgets.sizedBox(5, 0),
                          Widgets.divider(),
                          Widgets.sizedBox(5, 0),
                          Text(
                            "PROGRESS",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp),
                          ),
                          Widgets.sizedBox(5, 0),
                          Widgets.divider(),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            isFirst: true,
                            indicatorStyle: IndicatorStyle(
                              color: MyColors.goodColor,
                            ),
                            afterLineStyle: LineStyle(
                              color: MyColors.goodColor,
                            ),
                            endChild: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 10),
                              child: Text(
                                'Request ${ widget.isUser ? 'Submitted' : 'Received'}',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: MyColors.highlightColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              color: _status.contains('Approved')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            afterLineStyle: LineStyle(
                              color: _status.contains('Approved')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            beforeLineStyle: LineStyle(
                              color: _status.contains('Approved')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            endChild: Padding(
                              padding: !widget.isUser &&
                                      _status.contains('Pending') &&
                                      !_status.contains('Approved')
                                  ? EdgeInsets.only(left: 10, right: 40.w)
                                  : EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 10),
                              child: !widget.isUser &&
                                      _status.contains('Pending') &&
                                      !_status.contains('Approved')
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(
                                            status: 'Loading...',
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        await UpdateData.updateReq(
                                          widget.reqId,
                                          this.context,
                                          'Approved',
                                        );
                                        EasyLoading.dismiss();
                                      },
                                      style: Styles.roundButtonStyle(),
                                      child: Text("Click to Approve"),
                                    )
                                  : Text(
                                      'Request Confirm',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              color: _status.contains('On the Way')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            afterLineStyle: LineStyle(
                              color: _status.contains('On the Way')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            beforeLineStyle: LineStyle(
                              color: _status.contains('On the Way')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            endChild: Padding(
                              padding: !widget.isUser &&
                                      _status.contains('Approved') &&
                                      !_status.contains('On the Way')
                                  ? EdgeInsets.only(left: 10, right: 40.w)
                                  : EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 10),
                              child: !widget.isUser &&
                                      _status.contains('Approved') &&
                                      !_status.contains('On the Way')
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(
                                            status: 'Loading...',
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        await UpdateData.updateReq(
                                          widget.reqId,
                                          this.context,
                                          'On the Way',
                                        );
                                        EasyLoading.dismiss();
                                      },
                                      style: Styles.roundButtonStyle(),
                                      child: Text("Click if On the Way"),
                                    )
                                  : Text(
                                      'On the Way',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              color: _status.contains('Reached')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            afterLineStyle: LineStyle(
                              color: _status.contains('Reached')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            beforeLineStyle: LineStyle(
                              color: _status.contains('Reached')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            endChild: Padding(
                              padding: widget.isUser &&
                                      (_status.contains('On the Way') &&
                                          !_status.contains('Reached'))
                                  ? EdgeInsets.only(left: 10, right: 40.w)
                                  : EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 10),
                              child: widget.isUser &&
                                      (_status.contains('On the Way') &&
                                          !_status.contains('Reached'))
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(
                                            status: 'Loading...',
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        await UpdateData.updateReq(
                                          widget.reqId,
                                          this.context,
                                          'Reached',
                                        );
                                        EasyLoading.dismiss();
                                      },
                                      style: Styles.roundButtonStyle(),
                                      child: Text("Click if Reached"),
                                    )
                                  : Text(
                                      'Reached',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              color: _status.contains('Complete')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            afterLineStyle: LineStyle(
                              color: _status.contains('Complete')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            beforeLineStyle: LineStyle(
                              color: _status.contains('Complete')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            endChild: Padding(
                              padding: widget.isUser &&
                                      (_status.contains('Reached') &&
                                          !_status.contains('Complete'))
                                  ? EdgeInsets.only(left: 10, right: 40.w)
                                  : EdgeInsets.symmetric(
                                      vertical: 3.h, horizontal: 10),
                              child: widget.isUser &&
                                      (_status.contains('Reached') &&
                                          !_status.contains('Complete'))
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        EasyLoading.show(
                                            status: 'Loading...',
                                            maskType:
                                                EasyLoadingMaskType.black);
                                        await UpdateData.updateReq(
                                          widget.reqId,
                                          this.context,
                                          'Complete',
                                        );
                                        EasyLoading.dismiss();
                                      },
                                      style: Styles.roundButtonStyle(),
                                      child: Text("Click if Complete"),
                                    )
                                  : Text(
                                      'Completed',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: MyColors.highlightColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          TimelineTile(
                            alignment: TimelineAlign.start,
                            indicatorStyle: IndicatorStyle(
                              color: _status.contains('Bill Generated')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            afterLineStyle: LineStyle(
                              color: _status.contains('Bill Generated')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            beforeLineStyle: LineStyle(
                              color: _status.contains('Bill Generated')
                                  ? MyColors.goodColor
                                  : Colors.grey,
                            ),
                            isLast: true,
                            endChild: InkWell(
                              onTap: _status.contains('Bill Generated')
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Bill(
                                            id: billId,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Padding(
                                padding: !widget.isUser &&
                                        _status.contains('Complete') &&
                                        !_status.contains('Bill Generated')
                                    ? EdgeInsets.only(left: 10, right: 35.w)
                                    : EdgeInsets.symmetric(
                                        vertical: 3.h, horizontal: 10),
                                child: !widget.isUser &&
                                        _status.contains('Complete') &&
                                        !_status.contains('Bill Generated')
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BillGenerate(
                                                          id: widget.reqId)));
                                        },
                                        style: Styles.roundButtonStyle(),
                                        child: Text("Click to generate bill"),
                                      )
                                    : Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Bill Generated',
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                                color: MyColors.highlightColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          if (_status
                                              .contains('Bill Generated')) ...[
                                            Icon(
                                              MyIcons.invoice,
                                              color: MyColors.highlightColor,
                                            )
                                          ]
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          Text(
                            "Contact ${widget.isUser ? widget.spName : widget.name}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Widgets.whatsAppButton(widget.mob, ''),
                              Widgets.callButton(widget.mob),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  save() async {
    EasyLoading.showProgress(0.3, status: 'Loading...');
    final directory = (await getExternalStorageDirectory())!.path;
    String fileName = DateTime.now().toIso8601String();
    var path = '$directory/$fileName.png';
    screenshotController.captureAndSave(path).then((value) async {
      EasyLoading.dismiss();
      await Share.shareFiles(['$value']);
    });
  }
}
