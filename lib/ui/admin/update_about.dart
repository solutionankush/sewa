import 'package:flutter/material.dart';

import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/update_data.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';

class UpdateAbout extends StatefulWidget {
  @override
  _UpdateAboutState createState() => _UpdateAboutState();
}

class _UpdateAboutState extends State<UpdateAbout> {
  var title = 'Edit About Section';

  var about, email, contact, address;

  var _key;

  final aboutController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    _key = GlobalKey<FormState>();
  }

  getData() async {
    var data = await GettingData.getAboutSewa();
    aboutController.text = data[0]['about'];
    emailController.text = data[0]['email'];
    contactController.text = data[0]['contact'];
    addressController.text = data[0]['address'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var body = Widgets.containerWithCenterChild(
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
                  //Email TextFormField
                  TextFormField(
                    controller: emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter E-mail Address...";
                      }
                      return null;
                    },
                    onSaved: (e) => email = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('E-mail Address', MyIcons.mail),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Mobile Number TextFormField
                  TextFormField(
                    controller: contactController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.number,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter Contact Number...";
                      }
                      return null;
                    },
                    onSaved: (e) => contact = e,
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('Contact Number', MyIcons.phone),
                  ),
                  Widgets.sizedBox(10, 0),
                  //About TextFormField
                  TextFormField(
                    controller: aboutController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.words,
                    minLines: 5,
                    maxLines: 10,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter About...";
                      }
                      return null;
                    },
                    onSaved: (e) => about = e,
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco(
                        'About', MyIcons.info),
                  ),
                  Widgets.sizedBox(10, 0),
                  //Address TextFormField
                  TextFormField(
                    controller: addressController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.words,
                    minLines: 5,
                    maxLines: 8,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Enter Address...";
                      }
                      return null;
                    },
                    onSaved: (e) => address = e,
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco('Address', MyIcons.map),
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
                            shape: MaterialStateProperty.all(Styles.roundButtonShape()),
                            backgroundColor: MaterialStateProperty.all(MyColors.normalColor),
                            foregroundColor: MaterialStateProperty.all(MyColors.defaultTextColor),
                          ),
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {
                            final form = _key.currentState;
                            if (form.validate()) {
                              form.save();
                              UpdateData.updateAbout(
                                  context, about, contact, email, address);
                            }
                          },
                        ),
                      ),
                      Widgets.button(context, 'Cancel', MyColors.defaultTextColor,
                          MyColors.badColor, 0, 0.4, _key),
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

    return Widgets.scaffoldWithoutDrawer(title, body, context, null);
  }
}
