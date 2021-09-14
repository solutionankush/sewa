import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sewa/backend_work/getting_data.dart';
import 'package:sewa/backend_work/insert_data.dart';
import 'package:sewa/backend_work/payment.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/common/converter.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/common/icons.dart';
import 'package:sewa/common/variables.dart' as Variables;
import 'package:sewa/ui/user/payment_detail.dart';
import 'package:sizer/sizer.dart';

import '../../common/widgets.dart';

class Bill extends StatefulWidget {
  final id;

  Bill({Key? key, this.id}) : super(key: key);

  @override
  _BillState createState() => _BillState();
}

class _BillState extends State<Bill> {
  var bill;


  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var data = await GettingData.bill(widget.id);
    setState(() {
      bill = data[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = SingleChildScrollView(
      child: Column(
        children: [
         if(bill != null) ...[
           Stack(
             children: [
               ClipPath(
                 clipper: OvalBottomBorderClipper(),
                 child: Container(
                   height: 30.h,
                   width: 100.w,
                   color: MyColors.highlightColor.withOpacity(.7),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         'INVOICE #${bill['id'].toString().padLeft(4, '0')}',
                         style: TextStyle(
                           color: MyColors.bgColor,
                           fontSize: 18.sp,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       Widgets.sizedBox(2.h, 0),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                         children: [
                           Text(
                             'By : ${bill['sp_name']}',
                             style: TextStyle(
                               color: MyColors.bgColor,
                               fontSize: 14.sp,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                           Text(
                             'To : ${bill['name']}',
                             style: TextStyle(
                               color: MyColors.bgColor,
                               fontSize: 14.sp,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ],
                       ),
                       Widgets.sizedBox(5.h, 0),
                     ],
                   ),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.only(top: 20.h),
                 child: Center(
                   child: Container(
                     width: 90.w,
                     height: 4.h,
                     decoration: BoxDecoration(
                         color: MyColors.highlightColor.withOpacity(.8),
                         borderRadius: BorderRadius.circular(50)),
                   ),
                 ),
               ),
               Padding(
                 padding: EdgeInsets.only(top: 22.h),
                 child: ClipPath(
                   clipper: MultipleRoundedCurveClipper(),
                   child: Center(
                     child: Container(
                       decoration: BoxDecoration(boxShadow: [
                         BoxShadow(
                           blurRadius: 5.0,
                           color: Colors.grey.shade300,
                         )
                       ]),
                       width: 85.w,
                       padding: EdgeInsets.only(
                           top: 10, left: 10, right: 10, bottom: 35),
                       child: Column(
                         children: [
                           Text(
                             'INVOICE #${bill['id'].toString().padLeft(4, '0')}',
                             style: TextStyle(
                               color: MyColors.normalTextColor,
                               fontSize: 14.sp,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Row(
                             children: [
                               Expanded(
                                 child: Text(
                                   'Service Name :',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['service_name']}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             children: [
                               Expanded(
                                 child: Text(
                                   'Request on:',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['request_date'].toString().toDateTime()}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Expanded(
                                 child: Text(
                                   'Appointment on :',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['appointment_date'].toString().toDMYDate()} ${bill['appointment_time'].toString().padLeft(8, '0')}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Expanded(
                                 child: Text(
                                   'Reached at:',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['reached_time'].toString().toDateTime()}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Expanded(
                                 child: Text(
                                   'Complete at:',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['complete_time'].toString().toDateTime()}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Expanded(
                                 child: Text(
                                   'Paritcular :',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['paritcular']}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                               Expanded(
                                 child: Text(
                                   'Address :',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Text(
                                   '${bill['address']}',
                                   style: TextStyle(
                                     color: MyColors.normalTextColor,
                                     fontSize: 12.sp,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                           Text(
                             'Amount to Pay ₹ ${bill['amount']}',
                             style: TextStyle(
                               color: MyColors.normalTextColor,
                               fontSize: 18.sp,
                               fontWeight: FontWeight.bold,
                             ),
                           ),

                         ],
                       ),
                     ),
                   ),
                 ),
               ),
               if(bill['pay_id'] != '0') ...[
                 Padding(
                   padding: EdgeInsets.only(top: 30.h, left: 30.w),
                   child: Image.asset(Variables.Images.paid, scale: 15.sp,),
                 ),
               ]
             ],
           ),
           Widgets.sizedBox(5.h, 0),
           if (bill['pay_id'] == '0') ...[
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 20.w),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   if(Variables.userType == '2')...[
                     ElevatedButton(
                     onPressed: () {
                       Navigator.of(context).push(
                         MaterialPageRoute(
                           builder: (BuildContext _) => PaymentScreen(
                             amount: bill['amount'],
                             billId: bill['id'].toString(),
                           ),
                         ),
                       ).then((value) => getData(),);
                     },
                     style: ButtonStyle(
                       elevation: MaterialStateProperty.all(6),
                       backgroundColor:
                       MaterialStateProperty.all(MyColors.bgColor),
                       shape: MaterialStateProperty.all(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(50.0),
                         ),
                       ),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Image.asset(
                           Variables.Images.paytm,
                           scale: 25,
                         ),
                         Text(
                           'Pay with Paytm',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: MyColors.highlightColor),
                         ),
                       ],
                     ),
                   ),
                   ] else if(Variables.userType == '1') ...[
                     ElevatedButton(
                     onPressed: () {
                       InsertData.casePayment(
                           context, bill['id'], bill['amount']);
                     },
                     style: ButtonStyle(
                       elevation: MaterialStateProperty.all(6),
                       backgroundColor:
                       MaterialStateProperty.all(MyColors.bgColor),
                       shape: MaterialStateProperty.all(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(50.0),
                         ),
                       ),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Image.asset(
                           Variables.Images.cash,
                           scale: 20,
                         ),
                         Text(
                           'Pay with Cash',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: MyColors.highlightColor),
                         ),
                       ],
                     ),
                   ),
                   ],
                 ],
               ),
             )
           ] else ...[
             ElevatedButton.icon(
               onPressed: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentDetail(billId: bill['id'],),),);
               },
               style: ButtonStyle(
                 elevation: MaterialStateProperty.all(6),
                 backgroundColor:
                 MaterialStateProperty.all(MyColors.goodColor),
                 shape: MaterialStateProperty.all(
                   RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(50.0),
                   ),
                 ),
               ),
               icon: Icon(Icons.receipt_long_rounded, color: MyColors.bgColor,),
               label: Text(
                 'See Transaction Receipt',
                 style: TextStyle(
                     fontWeight: FontWeight.bold,
                     color: MyColors.bgColor),
               ),
             )
           ],
           ElevatedButton.icon(
             onPressed: () {
               Fun.goBack(context);
             },
             style: ButtonStyle(
               elevation: MaterialStateProperty.all(6),
               backgroundColor:
               MaterialStateProperty.all(MyColors.highlightColor),
               shape: MaterialStateProperty.all(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(50.0),
                 ),
               ),
             ),
             label: Text(
               'Go Back',
               textAlign: TextAlign.center,
               style: TextStyle(
                   fontWeight: FontWeight.bold,
                   color: MyColors.bgColor),
             ),
             icon: Icon(MyIcons.back,),
           ),
         ] else ...[
           Widgets.sizedBox(50.h, 0),
           Center(child: Widgets.loading(),)
         ]

        ],
      ),
    );
    return Widgets.scaffoldWithoutAppBar(
      RefreshIndicator(
        child: body,
        onRefresh: refresh,
      ),
      context,
    );
  }
}
