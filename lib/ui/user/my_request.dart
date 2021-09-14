import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms_undraw/ms_undraw.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sizer/sizer.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/converter.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';
import '../common/track_req.dart';

class MyRequest extends StatefulWidget {
  @override
  _MyRequestState createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  String? title = 'My Requests', search;

  var data = [];

  bool loading = true;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    getData();
    setState(() {});
  }

  getData() async {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
    var gettingData = search == null
        ? await GettingData.getUserRequestList()
        : await SearchData.searchReqByUser(search);

    if(mounted){
      setState(() {
        data = gettingData;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var body = WillPopScope(
      child: Column(
        children: [
          Form(
            key: _key,
            onChanged: () {
              var form = _key.currentState!;
              if (form.validate()) {
                form.save();
                getData();
              }
            },
            child: Card(
              color: MyColors.bgColor,
              elevation: 5,
              child: TextFormField(
                onSaved: (value) {
                  setState(() {
                    search = value;
                  });
                },
                style: Styles.formTextStyle(),
                textInputAction: TextInputAction.search,
                decoration: Styles.textFieldDeco(
                    'Search by service or user name....', MyIcons.search),
              ),
            ),
          ),
          loading
              ? Widgets.loading()
              : Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (data.isNotEmpty) ...[
                        for (int i = 0; i < data.length; i++) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text('${data[i]['service_name']}'),
                                subtitle: Text(
                                  'Current Status: ${data[i]['status']}',
                                ),
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  child: Image.network(
                                    Api.baseURL + data[i]['service_img'],
                                    fit: BoxFit.fill,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                trailing: Icon(
                                  data[i]['status'] == 'Paid' ? MyIcons.payment : data[i]['status'] == 'Bill Generated' ? MyIcons.invoice : MyIcons.pending,
                                  color: data[i]['status'] == 'Paid' ? MyColors.goodColor : data[i]['status'] == 'Bill Generated' ? MyColors.highlightColor : MyColors.badColor,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TrackReq(
                                        appointmentDatetime:
                                            "${data[i]['appointment_date'].toString().toDMYDate()} ${data[i]['appointment_time'].toString().padLeft(8, '0')}",
                                        reqDate: data[i]['request_date'],
                                        isUser: true,
                                        serviceName: data[i]['service_name'],
                                        name: data[i]['username'],
                                        spName: data[i]['vender_name'],
                                        remark: data[i]['remark'],
                                        reqId: data[i]['id'],
                                        address: data[i]['address'],
                                        mob: data[i]['mob'],
                                      ),
                                    ),
                                  ).then((value) => refresh());
                                },
                              ),
                            ),
                          ),
                        ],
                      ] else ...[
                        Widgets.sizedBox(18.h, 0),
                        Center(child: Column(
                          children: [
                            UnDraw(illustration: UnDrawIllustration.empty, color: Colors.red, height: 30.h,),
                            Text('No order of you', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.highlightColor),),
                          ],
                        ))
                      ],
                    ],
                  ),
                ),
        ],
      ),
      onWillPop: () {
        return Fun.router(context, Variables.Links.home);
      },
    );
    return Widgets.scaffoldWithoutDrawer(
        title,
        RefreshIndicator(
          child: body,
          onRefresh: refresh,
        ),
        context,
        null,
        center: false);
  }
}
