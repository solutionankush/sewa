import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../backend_work/getting_data.dart';

import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class AddSP extends StatefulWidget {
  @override
  _AddSPState createState() => _AddSPState();
}

class _AddSPState extends State<AddSP> {
  var title = 'Add Vendor';
  var _key, cityList = [], city;

  @override
  void initState() {
    getCity();
    super.initState();
    _key = GlobalKey<FormState>();
  }

  Future getCity() async {
    var jsonData = await GettingData.getCityList();
    setState(() {
      cityList = jsonData;
    });
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
                    items: cityList.map(
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
                        Variables.city = value;
                      });
                    },
                  ),

                  Widgets.sizedBox(10, 0),
                  //Name TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: (e) {
                      Pattern pattern =
                          r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                      RegExp regex = new RegExp(pattern as String);

                      if (e!.trim().isEmpty) {
                        return "Please Enter Name...";
                      } else if(!regex.hasMatch(e.trim())) {
                        return 'Invalid username';
                      }
                      return null;
                    },
                    onSaved: (e) => Variables.name = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('Name of Vendor', MyIcons.person),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Address TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.words,
                    minLines: 2,
                    maxLines: 4,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter Address...";
                      }
                      return null;
                    },
                    onSaved: (e) => Variables.add = e,
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco('Address', MyIcons.map),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Email TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (e) => EmailValidator.validate(e!)? null:"Invalid email address",
                    onSaved: (e) => Variables.email = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('E-mail Address', MyIcons.mail),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Mobile Number TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.number,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter Mobile Number...";
                      } if(e.length != 10){
                        return 'Mobile Number must be of 10 digit';
                      }
                      return null;
                    },
                    onSaved: (e) => Variables.mob = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('Mobile Number', MyIcons.phone),
                  ),
                  Widgets.sizedBox(25, 0),

                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Widgets.button(context, "Add", MyColors.defaultTextColor,
                          MyColors.normalColor, 3, 0.4, _key),
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
