import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend_work/apis.dart';
import '../ui/user/speech_screen.dart';
import 'colors.dart';
import 'converter.dart';
import 'functions.dart';
import 'icons.dart';
import 'styles.dart';
import 'variables.dart' as Variables;

class Widgets {
  //Dialog Box for success
  static successDialog(BuildContext context, title, desc, path) {
    EasyLoading.showSuccess(
      desc,
      duration: Duration(seconds: 3),
      dismissOnTap: true,
      maskType: EasyLoadingMaskType.black
    ).then((value) {
      if (path != null && path != 'home' && path != 'back') {
        Fun.router(context, path);
      } else if (path == 'home') {
        Fun.oneWayRouter(context, Variables.Links.login);
      } else if (path == 'back') {
        Fun.goBack(context);
      }
    });
  }

  //Dialog Box for Fail
  static failDialog(BuildContext context, title, desc, path) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      backgroundColor: MyColors.bgColor,
      title: title,
      text: desc,
      animType: CoolAlertAnimType.scale,
      onConfirmBtnTap: () {
        if (path != null && path != 'home' && path != 'back') {
          Fun.router(context, path);
        }
      },
      confirmBtnText: 'Ok',
    );
  }

  //Dialog Box for Warning
  static warningDialog(BuildContext context, title, desc) {
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.warning,
      backgroundColor: MyColors.bgColor,
      animType: CoolAlertAnimType.scale,
      title: title,
      text: desc,
      confirmBtnText: 'Ok',
      onConfirmBtnTap: () {
        Fun.goBack(context);
      },
      autoCloseDuration: Duration(seconds: 2),
    );
  }

  //Dialog Box for Info (User Req)
  static userInfoAlertDialog(
      BuildContext context, id, name) async {
    var service, req, amount;
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);
    final formatter = new NumberFormat("#,###.00");
    var res = await http.post(Api.getData, body: {
      'get_data': 'getSra',
      'id': id,
    });
    EasyLoading.dismiss();
    var data = jsonDecode(res.body);
    service = data[0]['service'];
    req = data[0]['req'];
    amount = data[0]['amount'] ?? '0';
    return CoolAlert.show(
      context: context,
      type: CoolAlertType.custom,
      // animType: CoolAlertAnimType.scale,
      loopAnimation: false,
      confirmBtnText: 'Ok',
      widget: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$name',
              style: Styles.headingTextStyle(MyColors.normalTextColor),
            ),
            Widgets.sizedBox(10, 0),
            Row(
              children: [
                Expanded(
                    child: Text(
                      'id : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text(id),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                      'Number of Services : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text("0${service ?? '0'}"),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                      'Total Requests : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text("0${req ?? '0'}"),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                      'Total Amount Earn : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text("₹ ${formatter.format(amount.toString().toInt())}/-"),
              ],
            ),
            Widgets.sizedBox(10, 0),
          ],
        ),
      ),
    );
  }

  static profileWithBorder(r, at) {
    return Container(
      padding: EdgeInsets.all(at == 'bottom' ? 0 : 5),
      decoration: BoxDecoration(
        color: Variables.userProfile == null || Variables.userProfile == 'null'
            ? MyColors.bgColor
            : MyColors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 3,
          color: MyColors.bgColor,
        ),
      ),
      child: Variables.userProfile == null || Variables.userProfile == 'null'
          ? Padding(
              padding: EdgeInsets.all(at == 'home' ? 0 : 8.0),
              child: Icon(
                MyIcons.person,
                color: MyColors.highlightColor,
                size: at == 'home' ? 60 : 140,
              ),
            )
          : CircleAvatar(
              radius: r.toString().toDouble(),
              backgroundImage: NetworkImage(
                Variables.userProfile.toString().contains('https:')
                    ? Variables.userProfile
                    : (Api.baseURL + Variables.userProfile),
              ),
            ),
    );
  }

  static loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static drawerListTile(context, text, icon, onTap) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        if (onTap != null && onTap != '' && onTap != 'update') {
          Fun.router(context, onTap);
        }
        if (onTap == '') {
          Fun.logout(context);
        }
      },
      title: Text(
        text,
        style: TextStyle(
            color: MyColors.normalTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 16),
      ),
      leading: Icon(
        icon,
        color: MyColors.themeColor,
        size: 30,
      ),
    );
  }

  static divider() {
    return Divider(
      color: MyColors.dividerColor,
      height: 0,
    );
  }

  static sizedBox(height, width) {
    return SizedBox(
      height: height.toString().toDouble(),
      width: width.toString().toDouble(),
    );
  }

  static floatingActionButton(icon, onTap, context) {
    return FloatingActionButton(
      onPressed: () {
        if (onTap != null) {
          Fun.router(context, onTap);
        }
      },
      child: Icon(
        icon,
        size: 30.0,
      ),
    );
  }

  static appBar(title, center, context, key) {
    return AppBar(
      centerTitle: Variables.userType == '2' ? (title is String) : center,
      elevation: 0,
      backwardsCompatibility: false,
      leading: !center
          ? Variables.userType != '2'
              ? IconButton(
                  icon: Image.asset(
                    Variables.Images.drawerImage,
                    height: 20,
                  ),
                  onPressed: () => key.currentState.openDrawer(),
                )
              : IconButton(
                  onPressed: () {
                    Fun.router(context, Variables.Links.home);
                  },
                  icon: Icon(MyIcons.home))
          : IconButton(
              icon: Icon(MyIcons.back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColors.themeColor,
          statusBarIconBrightness: Brightness.light),
      title: (title is String) ? Text(title) : title,
      actions: [
        if (Variables.userType == '2') ...[
          IconButton(
            icon: Icon(MyIcons.mic),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SpeechScreen()));
            },
          ),
          if (!center) ...[
            IconButton(
              icon: Icon(MyIcons.out),
              onPressed: () {
                Fun.logout(context);
              },
            ),
          ],
        ],
      ],
    );
  }

  static scaffoldWithDrawer(title, body, context, floatingActionButton) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              InkWell(
                onTap: Variables.username != null
                    ? () {
                        Fun.router(context, Variables.Links.profile);
                      }
                    : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: Styles.drawerHeaderDeco(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          profileWithBorder(32, 'home'),
                          sizedBox(0, 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Styles.drawerHeaderText(
                                  (Variables.username ?? 'Guest').toString(),
                                  context,
                                  .95),
                              Styles.drawerHeaderText(
                                  (Variables.userEmail ?? '').toString(),
                                  context,
                                  .55),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'Developed by Sun And Sun solution',
                          style: TextStyle(
                            color: MyColors.highlightColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: MyColors.bgColor,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        drawerListTile(context, 'Home', MyIcons.home, null),
                        if (Variables.userType == '0') ...[
                          drawerListTile(context, 'Vendors', MyIcons.group,
                              Variables.Links.spl),
                          drawerListTile(context, 'Add Vendor',
                              MyIcons.personAdd, Variables.Links.addSP),
                          drawerListTile(context, 'Voice Request', MyIcons.mic,
                              Variables.Links.voiceReq),
                        ] else if (Variables.userType == '1') ...[
                          drawerListTile(context, 'My Services',
                              MyIcons.service, Variables.Links.service),
                          drawerListTile(context, 'Add Services',
                              MyIcons.addService, Variables.Links.addService),
                          drawerListTile(context, 'Requests', MyIcons.req,
                              Variables.Links.req),

                        ] else if (Variables.userType == '2') ...[
                          drawerListTile(context, 'My Requests', MyIcons.req,
                              Variables.Links.myReq),
                          drawerListTile(context, 'My Bills', MyIcons.doc,
                              Variables.Links.myBills),
                        ],
                        divider(),
                        drawerListTile(context, 'About ${Variables.appName}',
                            MyIcons.info, Variables.Links.about),
                        if (Variables.username != null) ...[
                          drawerListTile(context, 'Profile', MyIcons.person,
                              Variables.Links.profile),
                        ],
                        drawerListTile(context, 'Logout', MyIcons.out, ''),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: appBar(title, false, context, _scaffoldKey),
      body: ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildOverscrollIndicator(
            context,
            Container(),
            ScrollableDetails(
              direction: AxisDirection.up,
              controller: ScrollController(),
            ),
          ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  static scaffoldWithoutDrawer(title, body, context, floatingActionButton,
      {center = true}) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(title, center, context, _scaffoldKey),
      body: ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildOverscrollIndicator(
            context,
            Container(),
            ScrollableDetails(
              direction: AxisDirection.up,
              controller: ScrollController(),
            ),
          ),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  static scaffoldWithoutAppBar(body, context) {
    return SafeArea(
      child: ScrollConfiguration(
        behavior: new ScrollBehavior()
          ..buildOverscrollIndicator(
            context,
            Container(),
            ScrollableDetails(
              direction: AxisDirection.up,
              controller: ScrollController(),
            ),
          ),
        child: Scaffold(
          body: body,
        ),
      ),
    );
  }

  static containerWithCenterChild(child) {
    return Container(
      child: Center(child: child),
    );
  }

  static centerText(text) {
    return Text(
      text,
      textAlign: TextAlign.center,
    );
  }

  static centerTextHeading(text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Styles.headingTextStyle(MyColors.normalTextColor),
    );
  }

  static containerWithCenterChildAndPadding(child, padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        child: Center(child: child),
      ),
    );
  }

  static button(
      context, text, Color textColor, Color? color, type, widthFactor, key) {
    return SizedBox(
      height: 44.0,
      width: MediaQuery.of(context).size.width * widthFactor,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: !Variables.isLoading
                ? MaterialStateProperty.all(color)
                : MaterialStateProperty.all(color!.withOpacity(.3)),
            foregroundColor: MaterialStateProperty.all(textColor),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
            shape: MaterialStateProperty.all(Styles.roundButtonShape())),
        child: Text(text),
        onPressed: !Variables.isLoading
            ? () {
                print('pressed');
                switch (type) {
                  case 0: // Cancel Button
                    Fun.goBack(context);
                    break;
                  case 1: // Login Button
                    Fun.check(1, context, key);
                    break;
                  case 2: // Register Button
                    // Fun.oneWayRouter(context, Variables.Links.selectCity);
                    break;
                  case 3: // Add SP by Admin
                    Fun.check(4, context, key);
                    break;
                  case 4: // Add user by SP
                    Fun.check(5, context, key);
                    break;
                  case 5: // Add Service by SP
                    Fun.check(6, context, key);
                    break;
                  case 6: //send request for service by user
                    Fun.check(7, context, key);
                    break;
                  default:
                    warningDialog(context, 'NOT DEFINE',
                        'Function of this button is not defined yet in on tap button');
                    break;
                }
              }
            : null,
      ),
    );
  }

  static selectDate(BuildContext context) async {
    var date;
    DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 15000)),
    );
    if (picked != null && picked != now) {
      var pick = DateTime.parse(DateFormat('yyyy-MM-dd').format(picked));
      date = "${pick.toLocal()}".split(' ')[0].toString();
    } else {
      var pick = DateTime.parse(DateFormat('yyyy-MM-dd').format(now));
      date = "${pick.toLocal()}".split(' ')[0].toString();
    }
    return date;
  }

  static selectTime(BuildContext context) async {
    var now = TimeOfDay.now();
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: now,
    );
    return time != null ? time.format(context) : now.format(context);
  }

  static whatsAppButton(number, msg) {
    var pLen = number.length;
    if (pLen == 10) {
      number = '+91' + number;
    }
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(Styles.roundButtonShape()),
          backgroundColor: MaterialStateProperty.all(MyColors.themeColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.fromLTRB(15, 5, 15, 5))),
      onPressed: () async => await launch("https://wa.me/$number?text=$msg"),
      child: Row(
        children: [
          Image.asset(
            Variables.Images.whatsAppImage,
            height: 25,
          ),
          sizedBox(0, 8),
          Text(
            'WhatsApp',
            style: TextStyle(fontSize: 14, color: MyColors.defaultTextColor),
          ),
        ],
      ),
    );
  }

  static callButton(number) {
    var pLen = number.length;
    if (pLen == 10) {
      number = '+91' + number;
    }
    return TextButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(Styles.roundButtonShape()),
          backgroundColor: MaterialStateProperty.all(MyColors.themeColor),
          padding:
              MaterialStateProperty.all(EdgeInsets.fromLTRB(15, 5, 15, 5))),
      onPressed: () => Fun.call(number),
      child: Row(
        children: [
          Image.asset(
            Variables.Images.callImage,
            height: 25,
          ),
          sizedBox(0, 8),
          Text(
            'Make a Call',
            style: TextStyle(fontSize: 14, color: MyColors.defaultTextColor),
          ),
        ],
      ),
    );
  }
}
