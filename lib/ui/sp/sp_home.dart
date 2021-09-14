import 'package:flutter/material.dart';
import 'package:sewa/ui/sp/voice_req_vendor.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';

import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class SPHome extends StatefulWidget {
  @override
  _SPHomeState createState() => _SPHomeState();
}

class _SPHomeState extends State<SPHome> {


  @override
  Widget build(BuildContext context) {
    var body = Column(
        children: [
          Expanded(
            child: GridView.count(

              primary: false,
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              children: [
                Card(
                  color: MyColors.themeColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Fun.router(context, Variables.Links.service);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            MyIcons.service,
                            size: 90,
                            color: MyColors.defaultTextColor,
                          ),
                          Text(
                            'My Services',
                            style: TextStyle(
                                color: MyColors.defaultTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: MyColors.themeColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Fun.router(context, Variables.Links.addService);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            MyIcons.addService,
                            size: 90,
                            color: MyColors.defaultTextColor,
                          ),
                          Text(
                            'Add Service',
                            style: TextStyle(
                                color: MyColors.defaultTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: MyColors.themeColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Fun.router(context, Variables.Links.req);
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            MyIcons.req,
                            size: 90,
                            color: MyColors.defaultTextColor,
                          ),
                          Text(
                            'Requests',
                            style: TextStyle(
                                color: MyColors.defaultTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: MyColors.themeColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceReqVendor(),));
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            MyIcons.mic,
                            size: 90,
                            color: MyColors.defaultTextColor,
                          ),
                          Text(
                            'Voice Request',
                            style: TextStyle(
                                color: MyColors.defaultTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                Fun.logout(context);
              },
              label: Text('Logout'),
              icon: Icon(MyIcons.out),
            ),
          ),
        ],
    );

    return Widgets.scaffoldWithDrawer(
      Variables.appName,
      body,
      context,
      null,
    );
  }
}
