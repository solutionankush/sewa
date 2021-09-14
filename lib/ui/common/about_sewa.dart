import 'package:flutter/material.dart';
import '../../common/colors.dart';

import '../../backend_work/getting_data.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class AboutSewa extends StatefulWidget {
  @override
  _AboutSewaState createState() => _AboutSewaState();
}

class _AboutSewaState extends State<AboutSewa> {
  var title = 'About ${Variables.appName}';

  @override
  Widget build(BuildContext context) {
    var body = FutureBuilder(
        future: GettingData.getAboutSewa(),
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
                            return SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                children: [
                                  Text(
                                    title,
                                    style: Styles.headingTextStyle(MyColors.normalTextColor),
                                  ),
                                  Widgets.sizedBox(10, 0),
                                  Text(
                                    list[index]['about'],
                                    textAlign: TextAlign.justify,
                                  ),
                                  Widgets.sizedBox(10, 0),
                                  Widgets.divider(),
                                  Widgets.sizedBox(10, 0),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Contact Number :-', style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Expanded(
                                        child: Text(
                                          list[index]['contact'],
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Widgets.sizedBox(10, 0),
                                  Row(
                                    children: [
                                      Expanded(child: Text('E-Mail :-', style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Expanded(
                                        child: Text(
                                          list[index]['email'],
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Widgets.sizedBox(10, 0),
                                  Row(
                                    children: [
                                      Expanded(child: Text('Address :-', style: TextStyle(fontWeight: FontWeight.bold),)),
                                      Expanded(
                                        child: Text(
                                          list[index]['address'],
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Widgets.sizedBox(50, 0),
                                ],
                              ),
                            );
                          }))
                  : Widgets.centerText('')
              : Widgets.loading();
        });
    return Widgets.scaffoldWithoutDrawer(title, body, context, null);
  }
}
