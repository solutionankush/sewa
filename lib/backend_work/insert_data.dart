import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:sewa/ui/user/payment_detail.dart';

import '../common/functions.dart';
import '../common/variables.dart' as Variables;
import '../common/widgets.dart';
import 'apis.dart';

class InsertData {
  static addService(context) async {
    if (Variables.sImg != null) {
      EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black,);
      final uri = Api.insertData;
      var request = http.MultipartRequest('POST', uri);

      request.fields['insert_data'] = 'service';
      request.fields['service_name'] = Variables.sName;
      request.fields['service_about'] = Variables.sAbout;
      request.fields['sp_uid'] = Variables.userUId;
      var pic = await http.MultipartFile.fromPath("image", Variables.sImg.path);
      request.files.add(pic);

      final response = await request.send();
      final data = await response.stream.bytesToString();
      print(data);
      EasyLoading.dismiss();
      Fun.showMSG(
          context,
          data,
          'New Service Added Successfully',
          'Congratulations',
          'Some Thing is Wrong',
          'Registration Failed',
          Variables.Links.service);
    } else {
      Widgets.warningDialog(context, "Upload Image", "Image not be empty");
    }
  }

  static sentRequest(context) async {

    var response = await http.post(Api.insertData, body: {
      'insert_data': 'sentRequest',
      'service_id': Variables.reqSid.toString(),
      'user_id': Variables.userUId.toString(),
      'date': Variables.reqDate.toString(),
      'time': Variables.reqTime.toString(),
      'add': Variables.reqAdd.toString(),
      'remark': Variables.reqRemark.toString(),
    });

    var data = response.body;

    Fun.showMSG(
        context,
        data,
        'Your Request has been Sent...',
        'Congratulations',
        'Some Thing is Wrong',
        'Failed',
        Variables.Links.myReq);
    return data;
  }

  static generateBill(context, reqId, amount, particular) async {
    print("$reqId, $amount, $particular");
    var response = await http.post(Api.insertData, body: {
      'insert_data': 'generateBill',
      'req_id': reqId,
      'amount': amount,
      'particular': particular,
    });

    var data = response.body;
    Fun.showMSG(context, data, 'Your Bill is successfully Generated...',
        'Congratulations', 'Some Thing is Wrong', 'Failed', 'back');
  }

  static userRegFirstByGoogle(name, email, photo, context) async {
    var res = await http.post(Api.loginReg, body: {
      'btn_action': 'userRegFirstByGoogle',
      'name': name,
      'email': email,
      'photo': photo,
    });

    var data = jsonDecode(res.body);
    print(data);
    if (data['query']) {
      print('successful');
      Variables.username = name;
      Variables.userProfile = photo;
      Variables.userEmail = email;
      Variables.userType = '2';
      Variables.userUId = data['uid'];
      Fun.savePref(context);
      (context as Element).markNeedsBuild();
    }
  }

  static addUserAddress(
      context, name, mob, pin, flat, area, landmark, city, addType) async {
    var res = await http.post(Api.insertData, body: {
      "insert_data": "userAddress",
      "user_uid": Variables.userUId,
      "name": name,
      "mob": mob,
      "pin": pin,
      "flat": flat,
      "area": area,
      "landmark": landmark,
      "city": city,
      "addType": addType,
    });
    var data = res.body;
    Fun.showMSG(context, data, 'Your New Address is saved...',
        'Congratulations', 'Some Thing is Wrong', 'Failed', 'back');
  }

  static addCity(context, cityName) async {
    var res = await http.post(Api.insertData, body: {
      "insert_data": "city",
      "city_name": cityName,
    });
    var data = jsonDecode(res.body);
    print(data);
    if (data == 1) {
      Widgets.warningDialog(context, "City already exists",
          "City '$cityName' already exists in database");
    } else {
      Fun.showMSG(
          context,
          data.toString(),
          "City '$cityName' added Successfully",
          "City added ",
          "Some thing is wrong",
          "ERROR",
          Variables.Links.cityList);
    }
  }

  static casePayment(context, billId, amount) async {
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);
    var response =
        await http.post(Uri.parse("${Api.paymentResponse}?bid=$billId"), body: {
      'TXNID': 'CASE_${Random().nextInt(900000) + 100000}',
      'ORDERID': 'SEWA_CASE_$billId',
      'BANKTXNID': 'CASE',
      'TXNAMOUNT': '$amount',
      'STATUS': 'TXN_SUCCESS',
      'RESPMSG': 'SUCCESS',
      'TXNDATE': '${DateTime.now()}',
      'GATEWAYNAME': 'CASE',
      'BANKNAME': 'CASE',
      'PAYMENTMODE': 'CASE',
    });
    var data = jsonDecode(response.body);
    print(data);
    EasyLoading.dismiss();
    if (data) {
      EasyLoading.showSuccess('Successfully Paid', maskType: EasyLoadingMaskType.black);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentDetail(
            billId: billId.toString(),
          ),
        ),
      );
    } else {
      EasyLoading.showError('Fail', maskType: EasyLoadingMaskType.black);
    }
  }
}
