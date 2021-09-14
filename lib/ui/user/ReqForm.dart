import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewa/backend_work/insert_data.dart';

import '../../backend_work/apis.dart';
import '../../common/colors.dart';
import '../../common/converter.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';
import 'addForm.dart';

class ReqForm extends StatefulWidget {
  @override
  _ReqFormState createState() => _ReqFormState();
}

class _ReqFormState extends State<ReqForm> {
  String? title = 'Request', add;
  var _key;
  List? myAddList = [];

  Future getAdd() async {
    var response = await http.post(Api.getData,
        body: {"get_data": "myAdd", "id": Variables.userUId});
    var jsonData = jsonDecode(response.body);
    setState(() {
      myAddList = jsonData;
      Variables.isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<FormState>();
    getAdd();
    Variables.reqDate = null;
    Variables.reqAdd = null;
    Variables.reqRemark = null;
    Variables.reqTime = null;
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Widgets.containerWithCenterChild(
      ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 20),
        children: [
          Text(
            'Request for "${Variables.reqName}"',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: MyColors.highlightColor,
                ),
            textAlign: TextAlign.center,
          ),
          Widgets.containerWithCenterChildAndPadding(
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Date
                  InkWell(
                    onTap: () async {
                      Variables.reqDate = await Widgets.selectDate(context);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            MyIcons.calendar,
                            size: 25,
                            color: MyColors.themeColor,
                          ),
                          Widgets.sizedBox(0, 15),
                          Text(
                            Variables.reqDate == null
                                ? 'Select Appointment Date'
                                : '${Variables.reqDate}'.toDMYDate(),
                            style: Styles.formTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Time
                  InkWell(
                    onTap: () async {
                      Variables.reqTime = await Widgets.selectTime(context);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Icon(
                            MyIcons.time,
                            size: 25,
                            color: MyColors.themeColor,
                          ),
                          Widgets.sizedBox(0, 15),
                          Text(
                            Variables.reqTime == null
                                ? 'Select Appointment Time'
                                : Variables.reqTime,
                            style: Styles.formTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Remark TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => Variables.reqRemark = e,
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco('Remarks ', MyIcons.doc),
                  ),
                  //Address TextFormField
                  DropdownButtonFormField(
                    value: Variables.reqAdd,
                    icon: Icon(
                      MyIcons.down,
                      color: MyColors.themeColor,
                    ),
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      labelText: 'Select Address',
                      prefixIcon: Icon(
                        MyIcons.map,
                        color: MyColors.themeColor,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (dynamic value) =>
                        value == null ? 'field required' : null,
                    items: myAddList!.map(
                      (list) {
                        return DropdownMenuItem(
                          child: Text(
                            "${list['add_type']} (${list['flat']})",
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: list['id'].toString(),
                          onTap: () {
                            setState(() {
                              add = "${list['add_type']} (${list['flat']})";
                            });
                          },
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        Variables.reqAdd = value;
                      });
                    },
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => AddForm()))
                          .then((value) {
                        setState(() {
                          getAdd();
                        });
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(width: 2, color: MyColors.themeColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MyIcons.add),
                        Widgets.sizedBox(0, 10),
                        Text('Add New Address'),
                      ],
                    ),
                  ),
                  Widgets.sizedBox(25, 0),
                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 44.0,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: !Variables.isLoading
                                  ? MaterialStateProperty.all(
                                      MyColors.normalColor)
                                  : MaterialStateProperty.all(
                                      MyColors.normalColor.withOpacity(.3)),
                              foregroundColor: MaterialStateProperty.all(
                                  MyColors.defaultTextColor),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 18)),
                              shape: MaterialStateProperty.all(
                                  Styles.roundButtonShape())),
                          child: Text("Add"),
                          onPressed: !Variables.isLoading
                              ? () {
                                  final form = _key.currentState;
                                  if (form.validate() &&
                                      Variables.reqDate != null &&
                                      Variables.reqTime != null) {
                                    form.save();
                                    if(!Variables.isLoading){
                                      setState(() {
                                        Variables
                                            .isLoading =
                                        true;
                                      });
                                      InsertData
                                          .sentRequest(
                                          context);
                                    }
                                  } else {
                                    if (Variables.reqDate == null &&
                                        Variables.reqTime == null) {
                                      Widgets.failDialog(
                                          context,
                                          'Failed',
                                          'Please Select Appointment Date and Time',
                                          null);
                                    }
                                  }
                                }
                              : null,
                        ),
                      ),
                      /*Widgets.button(context, "Add", MyColors.defaultTextColor,
                          MyColors.normalColor, 6, 0.4, _key),*/
                      Widgets.button(
                          context,
                          'Cancel',
                          MyColors.defaultTextColor,
                          MyColors.badColor,
                          0,
                          0.4,
                          _key),
                    ],
                  ),
                ],
              ),
            ),
            10.0,
          ),
        ],
      ),
    );

    return Widgets.scaffoldWithoutDrawer(
      title,
      body,
      context,
      null,
    );
  }
}
