import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../backend_work/apis.dart';
import '../../backend_work/search.dart';
import '../../common/functions.dart';
import 'list_of_service_of_sp.dart';

import '../../backend_work/getting_data.dart';
import '../../backend_work/update_data.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class SPList extends StatefulWidget {
  @override
  _SPListState createState() => _SPListState();
}

class _SPListState extends State<SPList> {
  final title = 'Vendors';
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
              if (form.validate()) {
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
                decoration: Styles.textFieldDeco(
                    'Search by service or user name....', MyIcons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: search == null
                  ? GettingData.getSPList()
                  : SearchData.searchSpByAdmin(search),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError)
                  print(
                      'print by list_of_service_provider.dart(30) => ${snapshot.error}');
                return snapshot.hasData
                    ? snapshot.data.length != 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  List list = snapshot.data;
                                  var text = list[index]['admin_approve'] == '1'
                                      ? 'Not Approved'
                                      : (list[index]['active_status'] == '0'
                                          ? 'Inactive'
                                          : 'Active');

                                  return Card(
                                    color: MyColors.bgColor,
                                    elevation: 5,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SpServiceList(
                                              email: list[index]['email'],
                                              add: list[index]['address'],
                                              mob: list[index]['mobile'],
                                              profile: list[index]
                                                  ['profile_pic'],
                                              id: list[index]['uid'],
                                              name: list[index]['name'],
                                              isAdmin: true,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: list[index]['profile_pic'] ==
                                              null
                                          ? Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                MyIcons.person,
                                                color: MyColors.highlightColor,
                                                size: 30,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 18,
                                              backgroundImage: NetworkImage(
                                                list[index]['profile_pic']
                                                        .contains('https:')
                                                    ? list[index]['profile_pic']
                                                    : (Api.baseURL +
                                                        list[index]
                                                            ['profile_pic']),
                                              ),
                                            ),
                                      title: Text(list[index]['name']),
                                      subtitle: Text(list[index]['city_name']),
                                      trailing: Switch(
                                        value: text == 'Active',
                                        activeColor: MyColors.goodColor,
                                        onChanged: (value) {
                                          if(value) {
                                            UpdateData.active(list[index]['id'],
                                                context, list[index]['name']);

                                          } else {
                                            UpdateData.inActive(
                                                list[index]['id'],
                                                context,
                                                list[index]['name']);

                                          }
                                          refresh();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                          )
                        : Center(
                              child: Widgets.centerText('No Vendor found'),
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
      RefreshIndicator(
        child: body,
        onRefresh: refresh,
      ),
      context,
      Widgets.floatingActionButton(
        MyIcons.personAdd,
        Variables.Links.addSP,
        context,
      ),
    );
  }
}
