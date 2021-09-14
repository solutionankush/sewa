import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/functions.dart';
import '../common/variables.dart' as variable;
import '../common/widgets.dart';
import 'apis.dart';
import 'getting_data.dart';

class UpdateData {
  static approve(id, context, name) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'approve',
      'id': id.toString(),
    });
    var data = response.body;
    Fun.showMSG(context, data, '$name Successfully Approved', 'Congratulations',
        'Some Thing is Wrong', 'Approval Failed', null);
  }

  static active(id, context, name) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'active',
      'id': id.toString(),
    });
    var data = response.body;
    Fun.showMSG(context, data, '$name now Active', 'Congratulations',
        'Some Thing is Wrong', 'Approval Failed', null);
  }

  static inActive(id, context, name) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'inActive',
      'id': id.toString(),
    });
    var data = response.body;
    Fun.showMSG(context, data, '$name now inactive', 'Congratulations',
        'Some Thing is Wrong', 'Approval Failed', null);
  }

  static activeService(id, context, name) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'activeService',
      'id': id.toString(),
    });
    var data = response.body;
    Fun.showMSG(context, data, '$name Service Active now', 'Congratulations',
        'Some Thing is Wrong', 'Approval Failed', null);
  }

  static inActiveService(id, context, name) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'inActiveService',
      'id': id.toString(),
    });
    var data = response.body;
    Fun.showMSG(context, data, '$name Service inactive now', 'Congratulations',
        'Some Thing is Wrong', 'Approval Failed', null);
  }

  static updateReq(id, context, status) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'updateReq',
      'id': id.toString(),
      'status': status,
    });
    var data = response.body;
    Fun.showMSG(context, data, 'Status Updated to "$status" Successfully',
        'Congratulations', 'Some Thing is Wrong', 'Failed', null);
  }

  static updatePayment(context, data, billId) async {
    print('in updatePayment fun');
    var response = await http.post(Api.updateData, body: {
      'update_data': 'updatePayment',
      'data': data,
      'billId': billId.toString(),
    });
    return response.body;
  }

  static updateAbout(context, about, contact, email, address) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'updateAbout',
      'about': about,
      'contact': contact,
      'email': email,
      'address': address,
    });
    var data = response.body;
    Fun.showMSG(context, data, 'Successfully Updated "About Section"',
        'Congratulations', 'Some Thing is Wrong', 'Failed', null);
  }

  static updateService(context, id, name, about, File img) async {
    final uri = Api.updateData;
    var request = http.MultipartRequest('POST', uri);

    request.fields['update_data'] = 'updateService';
    request.fields['id'] = id;
    request.fields['name'] = name;
    request.fields['about'] = about;
    var pic = await http.MultipartFile.fromPath("image", img.path);
    request.files.add(pic);

    final response = await request.send();
    final data = await response.stream.bytesToString();

    Fun.showMSG(
        context,
        data,
        '"Service" was updated successfully',
        'Congratulations',
        'Some Thing is Wrong',
        'Failed',
        variable.Links.service);
  }

  static uploadImage(context, var id, File image) async {
    final uri = Api.updateData;
    var request = http.MultipartRequest('POST', uri);
    request.fields['update_data'] = 'updateProfile';
    request.fields['user_type'] = variable.userType;
    request.fields['name'] = image.path.split("/").last;
    request.fields['id'] = id;
    var pic = await http.MultipartFile.fromPath("image", image.path);
    request.files.add(pic);
    var res = await request.send();
    await http.Response.fromStream(res).then((value) {
      print("response is : ${value.body}");
    });
    GettingData.getNewDP(context);
  }

  static updateUser(context, id, name, email, address) async {
    var response = await http.post(Api.updateData, body: {
      'update_data': 'updateUser',
      'id': id,
      'name': name,
      'email': email,
      'add': address,
    });
    var data = response.body;
    if (data == 'true') {
      variable.username = name;
      variable.userEmail = email;
      variable.userAdd = address;
      // ignore: invalid_use_of_protected_member
      (context as Element).reassemble();
    }
    Fun.showMSG(context, data, '"Your New Profile" was updated successfully',
        'Congratulations', 'Some Thing is Wrong', 'Failed', null);
    return data;
  }

  static updateUserData(context, name, city, mob, id) async {
    var res = await http.post(Api.updateData, body: {
      "update_data": "userData",
      "id": id,
      "name": name,
      "city": city,
      "mob": mob,
    });

    var data = res.body;
    if (data != '1') {
      variable.number = mob;
      variable.password = mob;
      variable.city = city;
      variable.username = name;
      Fun.savePref(context);
      (context as Element).markNeedsBuild();

      Fun.showMSG(
          context,
          data,
          "Your detail was updated Successfully",
          "Congratulation",
          "Some thing is wrong",
          "Failed",
          variable.Links.home);
    } else {
      Widgets.warningDialog(context, "Number Already Exist",
          "Number you are trying to enter is already exist. please try another number");
    }
  }

  static updateUserPass(context, id, old, newP, cNewP) async {
    var data = 'false';
    if (old == variable.password) {
      if (newP == cNewP) {
        var response = await http.post(Api.updateData, body: {
          'update_data': 'updateUserPass',
          'id': id,
          'pass': newP,
        });
        data = response.body;
        if (data == 'true') {
          variable.password = newP;
        }
        Fun.showMSG(
            context,
            data,
            '"Your New Password" was updated successfully',
            'Congratulations',
            'Some Thing is Wrong',
            'Failed',
            null);
      } else {
        Widgets.warningDialog(context, "Mismatch",
            "Both new Password and conform new password must be same");
      }
    } else {
      Widgets.warningDialog(
          context, "Incorrect", "Your old password is not you enter");
    }
    variable.isLoading = false;
    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();

    return data;
  }
}
