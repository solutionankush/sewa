import 'package:flutter/material.dart';

import '../../backend_work/getting_data.dart';
import '../../backend_work/update_data.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var title = 'Profile';
  bool _status = true, _pStatus = false;
  final _key = new GlobalKey<FormState>();

  var _name, _email, _add, _old, _new, _cNew;

  @override
  void initState() {
    super.initState();
    GettingData.getNewDP(context);
  }

  @override
  Widget build(BuildContext context) {
    var body = SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Material(
                elevation: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                    color: MyColors.themeColor,
                    image: DecorationImage(
                      image: AssetImage(Variables.Images.bannerImage),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 1.6,
                child: InkWell(
                  onTap: () async {
                    await Fun.getImage(context, Variables.userUId);
                  },
                  child: Widgets.profileWithBorder(80, 'profile'),
                ),
              ),
            ],
          ),
          Widgets.sizedBox(10, 0),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    children: [
                      Widgets.centerTextHeading(Variables.username),
                      Widgets.centerText(
                        Variables.userType == '0'
                            ? '(Sewa Admin)'
                            : (Variables.userType == '1'
                                ? '(Sewa Vendor)'
                                : '(Sewa User)'),
                      ),
                    ],
                  ),
                ),
              ),
              _status
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: MyColors.normalColor,
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _status = false;
                            });
                          },
                          child: Icon(
                            MyIcons.edit,
                            color: MyColors.defaultTextColor,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Widgets.sizedBox(10, 0),
          Container(
            // color: MyColors.,
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.0),
              child: Form(
                key: _key,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Text(
                        'Name',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: _status
                                ? Text(Variables.username.toString())
                                : TextFormField(
                                    initialValue: Variables.username.toString(),
                                    onSaved: (e) => _name = e,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Name",
                                    ),
                                    enabled: !(_status),
                                    autofocus: !(_status),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Mobile',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                              child: Text(Variables.number=='' ?'-' : Variables.number),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: _status
                                ? Text(Variables.userEmail.toString())
                                : TextFormField(
                                    initialValue: Variables.userEmail.toString(),
                                    onSaved: (e) => _email = e,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Email",
                                    ),
                                    enabled: !(_status),
                                    autofocus: !(_status),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    if(Variables.userType != '2')...[
                      Padding(
                        padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Address',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: _status
                                ? Text(Variables.userAdd.toString())
                                : TextFormField(
                                    initialValue: Variables.userAdd.toString(),
                                    minLines: 2,
                                    maxLines: 4,
                                    onSaved: (e) => _add = e,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Field can't be empty";
                                      }
                                      return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Address",
                                    ),
                                    enabled: !(_status),
                                    autofocus: !(_status),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    ],
                    if (_pStatus) ...[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Old Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                onSaved: (e) => _old = e,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field cant be Empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "Enter old Password"),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'New Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                onSaved: (e) => _new = e,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field cant be Empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "Enter new Password"),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Conform New Password',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                onSaved: (e) => _cNew = e,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Field cant be Empty";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: "Conform new Password"),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    !(_status)
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 45.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      child: new TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MyColors.goodColor),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    MyColors.defaultTextColor),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                            ))),
                                        child: new Text(Variables.isLoading
                                            ? "Saving....."
                                            : "Save"),
                                        onPressed: !Variables.isLoading
                                            ? () async {
                                                setState(() {
                                                  Variables.isLoading = true;
                                                });
                                                var form = _key.currentState!;
                                                if (form.validate()) {
                                                  form.save();
                                                  var update = await UpdateData
                                                      .updateUser(
                                                          context,
                                                          Variables.userUId,
                                                          _name,
                                                          _email,
                                                          _add,);
                                                  setState(() {
                                                    if (update == 'true') {
                                                      _status = true;
                                                      Variables.isLoading =
                                                          false;
                                                    } else {
                                                      Variables.isLoading =
                                                          false;
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    Variables.isLoading = false;
                                                  });
                                                }
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Container(
                                        child: new TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  MyColors.badColor),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  MyColors.defaultTextColor),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20.0),
                                          ))),
                                      child: new Text("Cancel"),
                                      onPressed: !Variables.isLoading
                                          ? () {
                                              setState(() {
                                                _status = true;
                                              });
                                            }
                                          : null,
                                    )),
                                  ),
                                  flex: 2,
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: _pStatus
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      child: new TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    MyColors.goodColor),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    MyColors.defaultTextColor),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0),
                                            ))),
                                        child: _pStatus
                                            ? Text("Save Password")
                                            : Text("Change Password"),
                                        onPressed: !Variables.isLoading
                                            ? () async {
                                                if (_pStatus) {
                                                  setState(() {
                                                    Variables.isLoading = true;
                                                  });
                                                  var form = _key.currentState!;
                                                  if (form.validate()) {
                                                    form.save();
                                                    var update =
                                                        await UpdateData
                                                            .updateUserPass(
                                                                context,
                                                                Variables
                                                                    .userUId,
                                                                _old,
                                                                _new,
                                                                _cNew);
                                                    setState(() {
                                                      if (update == 'true') {
                                                        _pStatus = false;
                                                        Variables.isLoading =
                                                            false;
                                                      } else {
                                                        Variables.isLoading =
                                                            false;
                                                      }
                                                    });
                                                  } else {
                                                    setState(() {
                                                      Variables.isLoading =
                                                          false;
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    _pStatus = !_pStatus;
                                                    Variables.isLoading = false;
                                                  });
                                                }
                                              }
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_pStatus) ...[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      MyColors.badColor),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      MyColors
                                                          .defaultTextColor),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        20.0),
                                              ))),
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            setState(() {
                                              _pStatus = !_pStatus;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Widgets.scaffoldWithoutDrawer(title, body, context, null, center: false,);
  }
}
