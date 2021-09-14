import 'package:flutter/material.dart';

import '../../backend_work/getting_data.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';
import 'vendor_service_pie_chart.dart';
import 'vendor_user_pie_chart.dart';
import 'vendors_earn_pie_chart.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  var title = 'Admin Panel';

  @override
  void initState() {
    super.initState();
    GettingData.getNewDP(context);
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var body = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
      child: Column(
        children: [
          Text(
            'Editing',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Widgets.sizedBox(10, 0),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Card(
                  child: InkWell(
                    onTap: () {
                      Fun.router(context, Variables.Links.updateAbout);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'About Section',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Fun.router(context, Variables.Links.cityList);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          'Cities Section',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Widgets.sizedBox(10, 0),
          Text(
            'Vendor - User Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 140,
            child: VendorUserPieChart(),
          ),
          Text(
            'Vendor - Service Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 140,
            child: VendorServicePieChart(),
          ),
          Text(
            'Vendors - Earn This Year',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 140,
            child: VendorEarnPieChart(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Fun.logout(context);
              },
              label: Text('Logout'),
              icon: Icon(MyIcons.out),
            ),
          ),
        ],
      ),
    );

    return Widgets.scaffoldWithDrawer(
      title,
      RefreshIndicator(
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox.fromSize(
              child: body,
              // size: ,
            )),
        onRefresh: refresh,
      ),
      context,
      null,
    );
  }
}
