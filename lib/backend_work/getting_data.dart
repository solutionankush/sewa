import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/functions.dart';
import '../common/variables.dart' as Variables;
import '../ui/user/reg.dart';
import 'apis.dart';
import 'insert_data.dart';

class GettingData {

  static getAboutSewa() async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'aboutSewa',
    });
    return jsonDecode(response.body);
  }

  static getUserByGoogle(name, email, photo, context) async {
    var check = await http.post(Api.getData, body: {
      'get_data': 'userInfo',
      'email': email,
    });

    var data = jsonDecode(check.body);
    if (data.length != 0) {
      Variables.username = data[0]['name'];
      Variables.userProfile = data[0]['profile_pic'];
      Variables.userEmail = data[0]['email'];
      Variables.userUId = data[0]['uid'];
      Variables.number = data[0]['mobile'];
      Variables.password = data[0]['password'];
      Variables.userType = data[0]['user_type'];
      Variables.userAdd = data[0]['address'];
      Variables.city = data[0]['city'];

      Fun.savePref(context);

      if (Variables.number == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Reg(
              name: Variables.username,
              email: Variables.userEmail,
              photoUrl: Variables.userProfile,
              city: Variables.city == '0' ? '1' : Variables.city,
            ),
          ),
        );
      } else {
        Fun.oneWayRouter(context, Variables.Links.home);
      }
      (context as Element).markNeedsBuild();
    } else {
      await InsertData.userRegFirstByGoogle(name, email, photo, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Reg(
                    name: name,
                    email: email,
                    photoUrl: photo,
                  )));
    }
  }

  static getNewDP(context) async {
    final response = await http.post(Api.getData, body: {
      "get_data": 'profile',
      "id": Variables.userUId,
    });
    final data = jsonDecode(response.body);
    var img = data['pic'];
    // var prf = await Fun.sharedPerf();
    Variables.userProfile = img;
    // prf.setString('profile', img);
    (context as Element).markNeedsBuild();
  }

  static bill(id) async {
    final response = await http.post(Api.getData, body: {
      "get_data": 'bill',
      "id": id,
    });
    return jsonDecode(response.body);
  }

  static getUserRequestList() async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'userRequestList',
      'uid': Variables.userUId,
    });
    return jsonDecode(response.body);
  }

  static getSpRequestListByAdmin(id) async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'spRequestListByAdmin',
      'id': id,
    });
    return jsonDecode(response.body);
  }

  static getUserRequestListByAdmin(id) async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'userRequestListByAdmin',
      'id': id,
    });
    return jsonDecode(response.body);
  }

  static getSPRequestList(at) async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'spRequestList',
      'pid': Variables.userUId,
      'at': at,
    });
    return jsonDecode(response.body);
  }

  static getServiceList() async {
    var response = await http.post(Api.getData,
        body: {'get_data': 'serviceList', 'pid': Variables.userUId});
    return jsonDecode(response.body);
  }

  static getBills() async {
    final response = await http.post(Api.getData, body: {
      "get_data": 'bills',
      "id": Variables.userUId,
    });
    return jsonDecode(response.body);
  }

  static getBillDetails(id) async {
    final response = await http.post(Api.getData, body: {
      "get_data": 'billDetails',
      "id": id,
    });
    return jsonDecode(response.body);
  }

  static getSPList() async {
    print('getting sp list');
    var response = await http.post(Api.getData, body: {
      'get_data': 'spList',
      'city': Variables.userType != '0' ? Variables.city : '',
    });
    return jsonDecode(response.body);
  }

  static getServiceListForAdmin(id) async {
    print(id);
    var response = await http.post(Api.getData, body: {
      'get_data': 'serviceListForAdmin',
      'id': id,
    });
    return jsonDecode(response.body);
  }

  static getServiceListForUser() async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'serviceListForUser',
      'city': Variables.city,
    });
    return jsonDecode(response.body);
  }

  static getCityList() async {
    var response =
        await http.post(Api.getData, body: {"get_data": "city"});
    return jsonDecode(response.body);
  }

  static getUserList() async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'userList',
    });
    return jsonDecode(response.body);
  }

  static getPaymentDetail(id) async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'paymentDetails',
      'billId' : id.toString(),
    });
    print('payment Detail');
    print(id);
    print(response.body);

    return jsonDecode(response.body);
  }

  static Future getUserReqBill() async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'getUserReqBill',
      'id': Variables.userUId,
    });
    return jsonDecode(response.body);
  }

  static currentStatus(id) async {
    var response = await http.post(Api.getData, body: {
      'get_data': 'currentStatus',
      'id': id,
    });
    return jsonDecode(response.body);
  }
}
