import 'package:flutter/material.dart';
import 'package:sewa/backend_work/update_data.dart';
import '../../backend_work/apis.dart';
import '../../common/functions.dart';
import '../user/service_details.dart';

import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class ServiceList extends StatefulWidget {
  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  final title = 'My Services';

  var search;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
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
                if(form.validate()) {
                  form.save();
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
                  decoration: Styles.textFieldDeco('Search by service or user name....', MyIcons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: search == null
                    ? GettingData.getServiceList()
                    : SearchData.searchServiceBySp(search),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? snapshot.data.length != 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                              child: ListView.builder(
                                  itemCount: snapshot.data.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    List list = snapshot.data;
                                    var text = list[index]['service_status'] == '0'
                                        ? 'Inactive'
                                        : 'Active';

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          top: index != 0 ? 10 : 0),
                                      child: Card(
                                        color: MyColors.bgColor,
                                        elevation: 4,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceDetails(
                                                      serviceName: list[index]
                                                      ['service_name'],
                                                      image: Api.baseURL +
                                                          list[index]
                                                          ['service_img'],
                                                      serviceId: list[index]
                                                      ['id'],
                                                      about: list[index]
                                                      ['service_about'],
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(Api
                                                          .baseURL +
                                                          list[index][
                                                          'service_img']),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        4)),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                height: 110,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      list[index]
                                                      ['service_name'],
                                                      style: Styles
                                                          .headingTextStyle(
                                                          MyColors
                                                              .highlightColor),
                                                      textAlign:
                                                      TextAlign.center,
                                                    ),
                                                  ),
                                                  Switch(
                                                    value: text == 'Active',
                                                    activeColor: MyColors.goodColor,
                                                    onChanged: (value) {
                                                      if(value) {
                                                        UpdateData.activeService(list[index]['id'],
                                                            context, list[index]['service_name']);

                                                      } else {
                                                        UpdateData.inActiveService(
                                                            list[index]['id'],
                                                            context,
                                                            list[index]['service_name']);

                                                      }
                                                      refresh();
                                                    },
                                                  ),
                                                ],
                                              ),
                                              Widgets.sizedBox(10, 0)
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            )
                          : Center(child: Widgets.centerText(
                                  'You do not have any services yet'),
                            )
                      : Widgets.loading();
                },
              ),
            )
          ],
        ),
        onWillPop: () {
          return Fun.router(context, Variables.Links.home);
        },
    );

    return Widgets.scaffoldWithoutDrawer(
      title,
      RefreshIndicator(child: body, onRefresh: refresh,),
      context,
      null,
    );
  }
}
