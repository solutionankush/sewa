import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/insert_data.dart';
import '../../common/colors.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
import '../../common/converter.dart';

class BillGenerate extends StatefulWidget {
  final id;

  BillGenerate({Key? key, required this.id}) : super(key: key);

  @override
  _BillGenerateState createState() => _BillGenerateState();
}

class _BillGenerateState extends State<BillGenerate> {
  String? title = "Bill Generate",
      sName,
      reachedTime,
      completeTime,
      userName,
      requestTime,
      amount,
      particular,
      appointmentDate,
      appointmentTime,
      address;
  GlobalKey<FormState>? _key;

  @override
  void initState() {
    super.initState();
    initFun();
    _key = GlobalKey<FormState>();
  }

  initFun() async {
    var bill = await GettingData.getBillDetails(widget.id);
    setState(() {
      sName = bill[0]['service_name'];
      reachedTime = bill[0]['reached_time'].toString().toDateTime();
      completeTime = bill[0]['complete_time'].toString().toDateTime();
      userName = bill[0]['name'];
      requestTime = bill[0]['request_date'].toString().toDateTime();
      appointmentDate = bill[0]['appointment_date'].toString().toDMYDate();
      appointmentTime = bill[0]['appointment_time'];
      address = bill[0]['address'];
    });
  }

  @override
  Widget build(BuildContext context) {

    var body = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Requested Datetime : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text('$requestTime', style: TextStyle(fontSize: 15),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Appointment Datetime : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text('$appointmentDate $appointmentTime', style: TextStyle(fontSize: 15),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reached Datetime : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text('$reachedTime', style: TextStyle(fontSize: 15),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed Datetime : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                Text('$completeTime', style: TextStyle(fontSize: 15),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              children: [
                Expanded(child: Text('Service Name : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),),
                Expanded(child: Text('    $sName', style: TextStyle(fontSize: 15),),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              children: [
                Expanded(child: Text('User Name : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),),
                Expanded(child: Text('    $userName', style: TextStyle(fontSize: 15),),),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Row(
              children: [
                Expanded(child: Text('Address : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),),
                Expanded(child: Text('$address', style: TextStyle(fontSize: 15),),),
              ],
            ),
            Widgets.sizedBox(10, 0),

            Form(
              key: _key,
              child: Column(
                children: [
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      onSaved: (value) {
                        setState(() {
                          amount = value!.trim();
                        });
                      },
                      validator: (e) {
                        if (e!.isEmpty && e.trim() == '') {
                          return "Please Enter....!";
                        }
                        return null;
                      },
                      style: Styles.formTextStyle(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2)),
                        contentPadding:
                        EdgeInsets.only(left: 8, right: 8, top: 14),
                        labelText: 'Enter Amount',
                      ),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  ListTile(
                    title: TextFormField(
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (value) {
                        setState(() {
                          particular = value!.trim();
                        });
                      },
                      validator: (e) {
                        if (e!.isEmpty && e.trim() == '') {
                          return "Please Enter....!";
                        }
                        return null;
                      },
                      style: Styles.formTextStyle(),
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2)),
                        contentPadding:
                        EdgeInsets.only(left: 8, right: 8, top: 14),
                        labelText: 'Enter Particular',
                      ),
                    ),
                  ),
                  Widgets.sizedBox(10, 0),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(MyColors.goodColor),
                      foregroundColor: MaterialStateProperty.all(MyColors.defaultTextColor),
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                      shape: MaterialStateProperty.all(Styles.roundButtonShape()),
                    ),
                    child: Text('Generate Bill'),
                    onPressed: () {
                      var form = _key!.currentState!;
                      if(form.validate()) {
                        form.save();
                        EasyLoading.showProgress(0.3, status: 'Loading...');
                        InsertData.generateBill(context,  widget.id, amount, particular);
                      } else {
                        Widgets.warningDialog(context, 'Not Validate', 'Fields not be empty');
                      }
                    },
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
    return Widgets.scaffoldWithoutDrawer(title, body, context, null);
  }
}
