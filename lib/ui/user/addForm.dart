import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../backend_work/apis.dart';
import '../../backend_work/insert_data.dart';

import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  var title = 'Add Address';
  GlobalKey<FormState>? _key;
  List? cityList = [];

  var name, mob, city, pinCode, flat, area, landMark, addType;


  Future getCity() async {
    var response =
    await http.post(Api.getData, body: {"get_data": "city"});
    var jsonData = jsonDecode(response.body);
    setState(() {
      cityList = jsonData;
    });
  }

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<FormState>();
    getCity();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Widgets.containerWithCenterChild(
      ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 20),
        children: [
          Widgets.containerWithCenterChildAndPadding(
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => name = e,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: ' First and Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    onSaved: (e) => mob = e,
                    keyboardType:  TextInputType.number,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : value.length !=10 ? "Enter 10 digit mobile number" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      hintText: '10-digit mobile number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    onSaved: (e) => pinCode = e,
                    keyboardType:  TextInputType.number,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : value.length !=6 ? "Enter 6 digit Pin code" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Pin Code',
                      hintText: '6-digit pin code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => flat = e,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Flat, House No., Company',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => area = e,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Area, Colony, Street, Sector, Village',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => landMark = e,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Landmark',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  DropdownButtonFormField(
                    value: city,
                    icon: Icon(
                      MyIcons.down,
                      color: MyColors.themeColor,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select City',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (dynamic value) => value == null ? 'field required' : null,
                    items: cityList!.map(
                          (list) {
                        return DropdownMenuItem(
                          child: Text(list['city'].toString()),
                          value: list['id'].toString(),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        city = value;
                      });
                    },
                  ),

                  Widgets.sizedBox(10, 0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => addType = e,
                    validator: (value) => value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'Address Type',
                      hintText: 'E.g. Home',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(20, 0),

                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 44.0,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(MyColors.normalColor),
                              foregroundColor: MaterialStateProperty.all(MyColors.defaultTextColor),
                              textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                              shape: MaterialStateProperty.all(Styles.roundButtonShape())
                          ),
                          child: Text("Add"),
                          onPressed: () {
                            var form = _key!.currentState!;
                            if(form.validate()) {
                              form.save();
                              InsertData.addUserAddress(context, name, mob, pinCode, flat, area, landMark, city, addType);
                            }
                          },
                        ),
                      ),
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
