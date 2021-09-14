import 'package:flutter/material.dart';
import 'package:sewa/ui/common/service_view.dart';

import '../../backend_work/apis.dart';
import '../../backend_work/getting_data.dart';
import '../../backend_work/search.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';

class SpServiceList extends StatefulWidget {
  final id, name, email, mob, add, profile, isAdmin;

  SpServiceList({
    Key? key,
    this.name,
    this.id,
    this.email,
    this.mob,
    this.add,
    this.profile,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _SpServiceListState createState() => _SpServiceListState();
}

class _SpServiceListState extends State<SpServiceList> {
  var search;
  bool showTop = true, showService = false, showRequest = false;

  GlobalKey<FormState> _key = GlobalKey<FormState>();
  var services = [];
  bool loading = true;

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
        ? await GettingData.getServiceListForAdmin(widget.id)
        : await SearchData.searchServiceByAdmin(search, widget.id);

    setState(() {
      services = gettingService;
      loading = false;
    });
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var title = "${widget.name}'s Services";

    var body = SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
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
                    search = value!.isEmpty ? null : value;
                  });
                  getData();
                },
                style: Styles.formTextStyle(),
                textInputAction: TextInputAction.search,
                decoration: Styles.textFieldDeco(
                    'Search by service or user name....', MyIcons.search),
              ),
            ),
          ),
          if (search == null && showTop) ...[
            Widgets.sizedBox(10, 0),
            Widgets.divider(),
            Widgets.sizedBox(10, 0),
            if(widget.isAdmin) ...[
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Icon(
                      MyIcons.info,
                      color: MyColors.highlightColor,
                    ),
                    onTap: (){
                      Widgets.userInfoAlertDialog(context, widget.id, widget.name);
                    },
                  ),
                ),
              ),
            ],
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: widget.profile == null || widget.profile == 'null'
                    ? MyColors.bgColor
                    : MyColors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 3,
                  color: MyColors.highlightColor,
                ),
              ),
              child: widget.profile == null || widget.profile == 'null'
                  ? Icon(
                      MyIcons.person,
                      color: MyColors.highlightColor,
                      size: 50,
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        widget.profile.toString().contains('https:')
                            ? widget.profile
                            : (Api.baseURL + widget.profile),
                      ),
                    ),
            ),
            Text(
              widget.name ?? '',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors.highlightColor),
            ),
            Text(
              "(${widget.add ?? ''})",
              style: TextStyle(
                  fontSize: 12,
                  color: MyColors.highlightColor,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.justify,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Widgets.whatsAppButton(widget.mob,
                    "Hello *${widget.name.trim()}*, \nI'm *${Variables.username.trim()}*"),
                Widgets.callButton(widget.mob),
              ],
            ),
            Widgets.sizedBox(10, 0),
            Widgets.divider(),
          ],
          Text(
            '  Services of ${widget.name}  ',
            style: TextStyle(
              fontSize: 20,
              color: MyColors.highlightColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Widgets.sizedBox(10, 0),
          loading
              ? Widgets.loading()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: ServiceView(services: services),
                ),
        ],
      ),
    );

    return Widgets.scaffoldWithoutDrawer(
      title,
      RefreshIndicator(
        child: body,
        onRefresh: refresh,
      ),
      context,
      null,
    );
  }
}
