import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/common/icons.dart';
import 'package:sewa/common/styles.dart';

class AppointVoice extends StatefulWidget {
  final id, user, city;

  const AppointVoice(
      {Key? key, required this.id, required this.user, required this.city})
      : super(key: key);

  @override
  _AppointVoiceState createState() => _AppointVoiceState();
}

class _AppointVoiceState extends State<AppointVoice> {
  var _vendor;
  String remark = '';
  List vendorList = [];

  @override
  void initState() {
    super.initState();
    getVendor();
  }

  getVendor() async {
    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);
    var response = await http.post(Api.getData, body: {
      "get_data": "voiceVendor",
      "city": widget.city,
    });
    print(response.body);
    var jsonData = jsonDecode(response.body);
    setState(() {
      vendorList = jsonData;
    });
    EasyLoading.dismiss();
    if (vendorList.length <= 0) {
      EasyLoading.showError('No Vendor in ${widget.city}',
          maskType: EasyLoadingMaskType.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Appoint Vendor',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: _vendor,
              icon: Icon(
                MyIcons.down,
              ),
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
              ),
              hint: Text('Select Vendor'),
              validator: (dynamic value) =>
                  value == null ? 'field required' : null,
              items: vendorList.map(
                (list) {
                  return DropdownMenuItem(
                    child: Text(
                      list['name'].toString(),
                    ),
                    value: list['uid'].toString(),
                  );
                },
              ).toList(),
              onChanged: (dynamic value) {
                setState(() {
                  _vendor = value;
                });
              },
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            onChanged: (e) => remark = e,
            validator: (value) => value!.isEmpty ? "Field can't empty" : null,
            style: Styles.formTextStyle(),
            decoration: InputDecoration(
              labelText: 'Remark',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async{
            if(_vendor != null) {
              EasyLoading.show(status: 'Loading....', maskType: EasyLoadingMaskType.black);
              var res = await http.post(Api.updateData, body: {
                "update_data" : "voiceAppoint",
                "id" : widget.id,
                "remark" : remark.trim(),
                "vendor" : _vendor,
              });
              EasyLoading.dismiss();
              if(jsonDecode(res.body)) {
                EasyLoading.showSuccess('Appoint successfully', maskType: EasyLoadingMaskType.black);
                Navigator.pop(context);
              } else {
                EasyLoading.showError('Appoint Failed', maskType: EasyLoadingMaskType.black);
              }
            } else {
              EasyLoading.showError('Select vendor to appoint',
                  maskType: EasyLoadingMaskType.black);
            }
          },
          child: Text('Appoint'),
        ),
        TextButton(
          onPressed: () async{
            if(remark.trim() != '') {
              EasyLoading.show(status: 'Loading....', maskType: EasyLoadingMaskType.black);
              var res = await http.post(Api.updateData, body: {
                "update_data" : "voiceCancel",
                "id" : widget.id,
                "remark" : remark.trim(),
              });
              EasyLoading.dismiss();
              if(jsonDecode(res.body)) {
                EasyLoading.showSuccess('Request cancel successfully', maskType: EasyLoadingMaskType.black);
                Navigator.pop(context);
              } else {
                EasyLoading.showError('Request cancel Failed', maskType: EasyLoadingMaskType.black);
              }
            } else {
              EasyLoading.showError('Enter some Remark to cancel',
                  maskType: EasyLoadingMaskType.black);
            }
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
