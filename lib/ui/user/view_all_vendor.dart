import 'package:flutter/material.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/backend_work/getting_data.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/common/icons.dart';
import 'package:sewa/common/variables.dart' as Variables;
import 'package:sewa/common/widgets.dart';
import 'package:sewa/ui/admin/list_of_service_of_sp.dart';

class ViewAllVendor extends StatefulWidget {
  @override
  _ViewAllVendorState createState() => _ViewAllVendorState();
}

class _ViewAllVendorState extends State<ViewAllVendor> {

  @override
  Widget build(BuildContext context) {
    var body = Container(
        child: FutureBuilder(
          future: GettingData.getSPList(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? snapshot.data.length != 0
                    ? Column(
                        children: [
                          Widgets.sizedBox(10, 0),
                          Flexible(
                            child: GridView.builder(
                              itemCount: snapshot.data.length,
                              // itemCount: snapshot.data.length,
                              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (context, index) {
                                List list = snapshot.data;
                                return Card(
                                  elevation: 0,
                                  color: MyColors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SpServiceList(
                                                name: list[index]['name'],
                                                id: list[index]['uid'],
                                                mob: list[index]['mobile'],
                                                add: list[index]['address'],
                                                email: list[index]['email'],
                                                profile: list[index]
                                                ['profile_pic'],
                                                isAdmin: false,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        list[index]['profile_pic'] != null
                                            ? CircleAvatar(
                                          backgroundImage:
                                          NetworkImage(
                                            list[index]['profile_pic']
                                                .toString()
                                                .contains(
                                                'https:')
                                                ? list[index]
                                            ['profile_pic']
                                                : (Api.baseURL +
                                                list[index][
                                                'profile_pic']),
                                          ),
                                          radius: 25,
                                        )
                                            : CircleAvatar(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.all(10),
                                            child: Icon(
                                              MyIcons.person,
                                              color: MyColors
                                                  .defaultTextColor,
                                              size: 30,
                                            ),
                                          ),
                                          radius: 25,
                                          backgroundColor:
                                          MyColors.highlightColor,
                                        ),
                                        Text(
                                          list[index]['name'].toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color:
                                              MyColors.highlightColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Widgets.sizedBox(50, 0),
                        ],
                      )
                    : Container()
                : Variables.city == null
                    ? Container()
                    : Widgets.loading();
          },
        ),
    );
    return Widgets.scaffoldWithoutDrawer("Vendors", body, context, null);
  }
}
