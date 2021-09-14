/*
import 'package:flutter/material.dart';

import '../../backend_work/apis.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  var search;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var title = "Users List";

    var body = Column(
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
                ? GettingData.getUserList()
                : SearchData.searchUserByAdmin(search),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? snapshot.data.length != 0
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              List list = snapshot.data;
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Widgets.userInfoAlertDialog(
                                      context,
                                      list[index]['name'],
                                      list[index]['email'],
                                      list[index]['mobile'],
                                      list[index]['uid'],
                                      true,
                                    );
                                  },
                                  leading: list[index]['profile_pic'] == null
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
                                                    list[index]['profile_pic']),
                                          ),
                                        ),
                                  title: Text(list[index]['name']),
                                ),
                              );
                            },
                          ),
                        )
                      : Widgets.centerText(
                          'No user found',
                        )
                  : Widgets.loading();
            },
          ),
        )
      ],
    );

    return Widgets.scaffoldWithoutDrawer(
      title,
      RefreshIndicator(child: body, onRefresh: refresh,),
      context,
      null,
    );
  }
}
*/
