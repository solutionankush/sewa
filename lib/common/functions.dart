import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend_work/apis.dart';
import '../backend_work/insert_data.dart';
import '../backend_work/update_data.dart';
import 'variables.dart' as Variables;
import 'widgets.dart';

class Fun {
  //for SharedPreferences
  static sharedPerf() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref;
  }

  //for One Way Router
  static oneWayRouter(context, path) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, path);
    });

  }

  //for Round Way Router
  static router(context, path) {
    Navigator.pushNamed(context, path);
  }

  //for Going Back
  static goBack(context) {
    Navigator.pop(context, true);
  }

  //for Form Validation Check
  static check(formType, context, key) {
    print("checking");
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      switch (formType) {
        case 1: // login
          login(context);
          break;
        // case 2 : //SP Reg from Login Page
        //   break;
        // case 3 : // User Reg from Login Page
        //   break;
        case 4: //SP Reg from Admin Side
          spReg(context);
          break;
        // case 5: //
        //   break;
        case 6: //Add Service from SP Side
          InsertData.addService(context);
          break;
        case 7: //send request for service by user

          showModalBottomSheet(
              context: context,
              builder: (context) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("Hello"),
                      ],
                    ),
                  ),
                );
              });

          // InsertData.sentRequest(context);
          break;
        default:
          Widgets.warningDialog(context, 'NOT DEFINE',
              'Function of this button is not defined yet in check fun');
          break;
      }
    }
  }

  static showMSG(
      context, data, successMSG, successTitle, failMSG, failTitle, pop) {
    if (data == 'true') {
      Widgets.successDialog(context, successTitle, successMSG, pop);
    } else {
      Widgets.failDialog(context, failTitle, failMSG, pop);
    }
  }

  //for SP Reg
  static spReg(context) async {
    final response = await http.post(Api.loginReg, body: {
      "btn_action": 'spReg',
      "name": Variables.name,
      "add": Variables.add,
      "email": Variables.email,
      "mob": Variables.mob,
      "user_type": '1',
      "parent_uid": Variables.userUId,
      "city": Variables.city,
    });
    var data = response.body;
    showMSG(context, data, 'New Vendor Successfully Added', 'Congratulations',
        'Some Thing is Wrong', 'Registration Failed', Variables.Links.spl);
  }

  //for Login
  static login(context) async {
    var response = await http.post(Api.loginReg, body: {
      "btn_action": 'login',
      "number": Variables.number,
      "pass": Variables.password,
    });
    var data = jsonDecode(response.body);
    print(data);
    if (data[0] == 'no_user_found') {
      return 'Invalid Mobile Number or Password';
    } else {
      Variables.userType = data[0]['user_type'];
      Variables.userUId = data[0]['uid'];
      Variables.username = data[0]['name'];
      Variables.userEmail = data[0]['email'];
      Variables.userAdd = data[0]['address'];
      Variables.userProfile = data[0]['profile_pic'];

      if (Variables.userType == '0') {
        savePref(context);
        oneWayRouter(context, Variables.Links.home);
      } else {
        if (data[0]['admin_approve'] == '0' &&
            data[0]['active_status'] == '1') {
          savePref(context);
          oneWayRouter(context, Variables.Links.home);
        } else {
          Widgets.failDialog(
              context,
              'Authentication Failed',
              'You are not approved by vendor or inactive kindly contact',
              null);
        }
      }
      return '';
    }
  }

  //for Save Pref (User Details)
  static savePref(context) async {
    SharedPreferences pref = await sharedPerf();
    print('in savePref');
    await pref.setString('id', Variables.userUId.toString());
    await pref.setString('name', Variables.username.toString());
    await pref.setString('userType', Variables.userType.toString());
    await pref.setString('email', Variables.userEmail.toString());
    await pref.setString('add', Variables.userAdd.toString());
    await pref.setString('number', Variables.number.toString());
    await pref.setString('pass', Variables.password.toString());
    await pref.setString('profile', Variables.userProfile.toString());
    await pref.setString('city', Variables.city.toString());
    print(pref.getString('userType'));
  }

  //for Logout
  static logout(context) async {
    var pref = await sharedPerf();
    pref.clear();
    Variables.userUId = null;
    Variables.username = null;
    Variables.userType = null;
    Variables.userEmail = null;
    Variables.userAdd = null;
    Variables.number = null;
    Variables.password = null;
    Variables.userProfile = null;

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }

    oneWayRouter(context, Variables.Links.login);
    Phoenix.rebirth(context);
  }

  static registerOnFirebase(var id) async {
    await Firebase.initializeApp();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.getToken().then((token) async {});
  }

  //for Switch User
  static switchUser(context) async {
    SharedPreferences pref = await sharedPerf();
    registerOnFirebase(pref.getString('id'));

    var userType = Variables.userType;
    print(userType);
    switch (userType) {
      case '0':
        oneWayRouter(context, Variables.Links.adminHome);
        break;
      case '1':
        oneWayRouter(context, Variables.Links.spHome);
        break;
      case '2':
        oneWayRouter(context, Variables.Links.userHome);
        break;
      default:
        oneWayRouter(context, Variables.Links.login);
        break;
    }
  }

  static call(phone) async {
    var pLen = phone.length;
    if (pLen == 10) {
      phone = '+91' + phone;
    }

    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      throw 'Could not Call Because number not available';
    }
  }

  static getImage(context, var id) async {
    var pickedImage =
        await (Variables.picker.getImage(source: ImageSource.gallery));
    var image = File(pickedImage!.path);
    UpdateData.uploadImage(context, id, image);
  }
}
