import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../backend_work/update_data.dart';
import '../../backend_work/apis.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class Reg extends StatefulWidget {
  final name, email, photoUrl, city;
  Reg ({Key? key, this.name, this.email, this.photoUrl, this.city}) : super(key: key);

  @override
  _RegState createState() => _RegState();
}

class _RegState extends State<Reg> {
  var _key = GlobalKey<FormState>();

  TextEditingController nameFiled = TextEditingController(), emailFiled = TextEditingController();


  var _name, _mob, _city;
  List? cityList = [];

  save() async {
    var form = _key.currentState!;
    if (form.validate()) {
      form.save();
      await UpdateData.updateUserData(context, _name, _city, _mob, Variables.userUId);
    }
  }

  @override
  void initState() {
    super.initState();
    getCity();
    nameFiled.text = widget.name;
    emailFiled.text = widget.email;
    _city = widget.city;
  }

  Future getCity() async {
    var response =
        await http.post(Api.getData, body: {"get_data": "city"});
    var jsonData = jsonDecode(response.body);
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
                    value: _city,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hint: Text('Select City'),
                    validator: (dynamic value) =>
                        value == null ? 'field required' : null,
                    items: cityList!.map(
                      (list) {
                        return DropdownMenuItem(
                          child: Text(list['city']),
                          value: list['id'].toString(),
                        );
                      },
                    ).toList(),
                    isExpanded: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        _city = value;
                      });
                    },
                  ),
                  Widgets.sizedBox(10, 0),
                  //Name TextFormField
                  TextFormField(
                    controller: nameFiled,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter Name...";
                      }
                      return null;
                    },
                    onSaved: (e) => _name = e,
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco('Name', MyIcons.person),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Email TextFormField
                  TextFormField(
                    controller: emailFiled,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    enabled: widget.email == null,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter E-mail Address...";
                      }
                      return null;
                    },
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
                      }
                      return null;
                    },
                    onSaved: (e) => _mob = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('Mobile Number', MyIcons.phone),
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
                              backgroundColor: MaterialStateProperty.all(
                                  MyColors.normalColor),
                              foregroundColor: MaterialStateProperty.all(
                                  MyColors.defaultTextColor),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 18)),
                              shape: MaterialStateProperty.all(
                                  Styles.roundButtonShape())),
                          child: Text('Add'),
                          onPressed: () {
                            save();
                          },
                        ),
                      ),
                      SizedBox(
                        height: 44.0,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(MyColors.badColor),
                              foregroundColor: MaterialStateProperty.all(
                                  MyColors.defaultTextColor),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 18)),
                              shape: MaterialStateProperty.all(
                                  Styles.roundButtonShape())),
                          child: Text('Later'),
                          onPressed: () {
                            Fun.oneWayRouter(context, Variables.Links.userHome);
                          },
                        ),
                      ),
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

    return Widgets.scaffoldWithoutDrawer('Registration', body, context, null);
  }
}
