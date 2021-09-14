import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../backend_work/apis.dart';

import '../../backend_work/update_data.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class AddService extends StatefulWidget {
  final id, name, about, img;

  AddService({Key? key, this.name, this.about, this.id, this.img}) : super(key: key);

  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  var title = 'Add Service';
  var _key;

  TextEditingController _name = TextEditingController();
  TextEditingController _about = TextEditingController();

  @override
  void initState() {
    super.initState();
    _key = GlobalKey<FormState>();
    _name.text = widget.name ?? '';
    _about.text = widget.about ?? '';
    Variables.sImg = null;
  }

  _imagePick() async {
    final picker = ImagePicker();
    var pickedImage = await picker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      Variables.sImg = File(pickedImage!.path);
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
                  //Service Name TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    controller: _name,

                    validator: (e) {
                      if (e!.trim().isEmpty) {
                        return "Please Enter Name...";
                      }
                      return null;
                    },
                    onSaved: (e) => Variables.sName = e!.trim(),
                    style: Styles.formTextStyle(),
                    decoration: Styles.textFieldDeco(
                        'Name of Services', MyIcons.service),
                  ),
                  Widgets.sizedBox(5, 0),
                  //Service About TextFormField
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.words,
                    controller: _about,
                    minLines: 2,
                    maxLines: 4,
                    validator: (e) {
                      if (e!.trim().isEmpty) {
                        return "Please Enter About Services...";
                      }
                      return null;
                    },
                    onSaved: (e) => Variables.sAbout = e!.trim(),
                    style: Styles.formTextStyle(),
                    decoration:
                        Styles.textFieldDeco('About Service', MyIcons.info),
                  ),
                  Widgets.sizedBox(5, 0),

                  if (Variables.sImg != null) ...[
                    Image.file(
                      Variables.sImg,
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Widgets.sizedBox(5, 0),
                  ] else if(widget.img != null) ...[
                    Image.network(
                     Api.baseURL + widget.img,
                      height: 180,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Widgets.sizedBox(5, 0),
                  ],
                  ElevatedButton(
                    onPressed: () {
                      _imagePick();
                    },
                    child: Text(
                       (Variables.sImg == null && widget.img == null ? 'Upload' : 'Change')+' Image',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: Styles.roundButtonStyle(),
                  ),

                  Widgets.sizedBox(25, 0),

                  //Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      widget.name == null
                          ? Widgets.button(
                              context,
                              "Add",
                              MyColors.defaultTextColor,
                              MyColors.normalColor,
                              5,
                              0.4,
                              _key)
                          : SizedBox(
                              height: 44.0,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        MyColors.normalColor),
                                    foregroundColor: MaterialStateProperty.all(
                                        MyColors.defaultTextColor),
                                    shape: MaterialStateProperty.all(
                                        Styles.roundButtonShape())),
                                child: Text(
                                  "Update",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if(Variables.sImg == null && widget.img != null) {
                                      Variables.sImg = widget.img;
                                    }
                                  });
                                  if (_key.currentState.validate() && Variables.sImg != null) {
                                    _key.currentState.save();
                                    UpdateData.updateService(context, widget.id,
                                        Variables.sName, Variables.sAbout, Variables.sImg);
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
