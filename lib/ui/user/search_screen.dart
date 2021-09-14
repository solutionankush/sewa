import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sewa/ui/common/service_view.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/widgets.dart';
// import '../../common/variables.dart' as Variables;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var search;
  var services = [];

  bool loading = true;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      loading = true;
    });
    var gettingService = search == null
        ? await GettingData.getServiceListForUser()
        : await SearchData.searchServiceByUser(search);
    setState(() {
      services = gettingService;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = SingleChildScrollView(
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
                  getData();
                },
                style: Styles.formTextStyle(),
                textInputAction: TextInputAction.search,
                decoration: Styles.textFieldDeco('Search by service or user name....', MyIcons.search),
              ),
            ),
          ),
          Widgets.sizedBox(10, 0),
          loading ? Widgets.loading() : Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: ServiceView(services: services),
          ),

        ],
      ),
    );

    return Widgets.scaffoldWithoutDrawer("Services", body, context, null,center: false);
  }
}
