import 'package:flutter/material.dart';
import '../../backend_work/insert_data.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';

class AddCity extends StatefulWidget {
  @override
  _AddCityState createState() => _AddCityState();
}

class _AddCityState extends State<AddCity> {
  var cityName;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var body = Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onSaved: (e) => cityName = e,
                    validator: (value) =>
                        value!.isEmpty ? "Field can't empty" : null,
                    style: Styles.formTextStyle(),
                    decoration: InputDecoration(
                      labelText: 'City Name',
                      hintText: 'E.g. Raipur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          var form = _key.currentState!;
                          if(form.validate()) {
                            form.save();
                            InsertData.addCity(context, cityName);
                          }
                        },
                        child: Text('Add City'),
                        style: Styles.roundButtonStyle(),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Fun.goBack(context);
                        },
                        child: Text('Cancel'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0))),
                            backgroundColor:
                                MaterialStateProperty.all(MyColors.badColor)),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    return Widgets.scaffoldWithoutDrawer('Add New City', body, context, null);
  }
}
