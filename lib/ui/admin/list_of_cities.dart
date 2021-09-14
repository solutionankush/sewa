import 'package:flutter/material.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class CitiesList extends StatefulWidget {
  @override
  _CitiesListState createState() => _CitiesListState();
}

class _CitiesListState extends State<CitiesList> {
  var search;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var title = "Cities";

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
                    ? GettingData.getCityList()
                    : SearchData.searchCities(search),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? snapshot.data!.length != 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child:  ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    List list = snapshot.data;
                                    return Card(
                                      color: MyColors.bgColor,
                                      elevation: 5,
                                      child: ListTile(
                                        onTap: () {},
                                        leading: Text(
                                          (index + 1).toString() + '.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        title: Text(
                                            list[index]['city'].toString()),
                                      ),
                                    );
                                  },
                                ),
                            )
                          : Center(
                                child: Widgets.centerText('City not added'),
                            )
                      : Widgets.loading();
                },
              ),
            )
          ],
        ),
        onWillPop: () {
          return Fun.router(context, Variables.Links.home);
        });

    return Widgets.scaffoldWithoutDrawer(
      title,
      RefreshIndicator(child: body, onRefresh: refresh,),
      context,
      Widgets.floatingActionButton(
          MyIcons.add, Variables.Links.addCity, context),
    );
  }
}
