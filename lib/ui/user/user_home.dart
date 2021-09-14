import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sewa/common/converter.dart';
import 'package:sewa/common/functions.dart';
import 'package:sewa/ui/common/profile.dart';
import 'package:sewa/ui/common/service_view.dart';
import 'package:sewa/ui/user/my_request.dart';
import 'package:sewa/ui/user/search_screen.dart';
import 'package:sewa/ui/user/view_all_vendor.dart';

import '../../backend_work/apis.dart';
import '../../backend_work/getting_data.dart';
import '../../common/colors.dart';
import '../../common/icons.dart';
import '../../common/variables.dart' as Variables;
import '../../common/widgets.dart';
import '../admin/list_of_service_of_sp.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var title = Variables.appName;

  List? cityList = [], vendors = [], services = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getData();
    getCity();
    if (Variables.city == '0') {
      Variables.city = '1';
    }
  }

  getData() async {
    setState(() {
      loading = true;
    });
    var gettingVendor = await GettingData.getSPList();
    var gettingService = await GettingData.getServiceListForUser();

    if(mounted){
      setState(() {
        vendors = gettingVendor;
        services = gettingService;
        loading = false;
      });
    }
  }

  getCity() async {
    var response =
        await http.post(Api.getData, body: {"get_data": "city"});
    var jsonData = jsonDecode(response.body);
    setState(() {
      cityList = jsonData;
    });
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = 170.toDouble();
    var body = SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: height,
            child: Column(
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vendors',
                          style: TextStyle(
                              color: MyColors.highlightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ViewAllVendor()));
                          },
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                    color: MyColors.highlightColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              Widgets.sizedBox(0, 5),
                              Icon(
                                MyIcons.go,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                        vendors!.length,
                        (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: index != 0 ? 8 : 4,
                                  right: index == vendors!.length - 1 ? 10 : 0),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                alignment: Alignment.topCenter,
                                child: Card(
                                  elevation: 0,
                                  color: MyColors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SpServiceList(
                                            name: vendors![index]['name'],
                                            id: vendors![index]['uid'],
                                            mob: vendors![index]['mobile'],
                                            add: vendors![index]['address'],
                                            email: vendors![index]['email'],
                                            profile: vendors![index]
                                                ['profile_pic'],
                                            isAdmin: false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        vendors![index]['profile_pic'] != null
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  vendors![index]['profile_pic']
                                                          .toString()
                                                          .contains('https:')
                                                      ? vendors![index]
                                                          ['profile_pic']
                                                      : (Api.baseURL +
                                                          vendors![index]
                                                              ['profile_pic']),
                                                ),
                                                radius: 25,
                                              )
                                            : CircleAvatar(
                                                child: Padding(
                                                  padding: EdgeInsets.all(10),
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
                                          vendors![index]['name'].toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: MyColors.highlightColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(
                              color: MyColors.highlightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                          },
                          child: Row(
                            children: [
                              Text(
                                'View All',
                                style: TextStyle(
                                    color: MyColors.highlightColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                              Widgets.sizedBox(0, 5),
                              Icon(
                                MyIcons.go,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ServiceView(services: services),
        ],
      ),
    );
    return Widgets.scaffoldWithoutDrawer(
        DropdownButtonFormField(
          value: Variables.city,
          icon: Icon(
            MyIcons.down,
            color: MyColors.defaultTextColor,
          ),
          dropdownColor: MyColors.themeColor,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
          ),
          hint: Text('Select City'),
          validator: (dynamic value) => value == null ? 'field required' : null,
          items: cityList!.map(
            (list) {
              return DropdownMenuItem(
                child: Text(
                  list['city'].toString(),
                  style: TextStyle(color: MyColors.defaultTextColor),
                ),
                value: list['id'].toString(),
              );
            },
          ).toList(),
          onChanged: (dynamic value) {
            setState(() {
              Variables.city = value;
            });
            Fun.savePref(context);
            getData();
          },
        ),
        loading
            ? Widgets.loading()
            : RefreshIndicator(
                child: body,
                onRefresh: refresh,
              ),
        context,
        null,
        center: false);
  }
}

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int selectedPage = 0;
  PersistentTabController? _controller;
  var currentBackPressTime;
  int req = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> _pageOptions() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Home(),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SearchScreen(),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: MyRequest(),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Profile(),
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(MyIcons.home),
        title: "Home",
        activeColorPrimary: MyColors.themeColor,
        inactiveColorPrimary: Colors.grey,

        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/',
          routes: Variables.routes,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(MyIcons.search),
        title: "Search",

        activeColorPrimary: MyColors.themeColor,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            print(settings);
            if (settings.name.toString() == '/') {
              print('Login');
            }
          },
          initialRoute: '/',
          routes: Variables.routes,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          children: [
            Icon(MyIcons.req),
            if (req != 0) ...[
              Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                      color: MyColors.badColor, shape: BoxShape.circle),
                  constraints: BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: new Text(
                    '$req',
                    style: new TextStyle(
                        color: MyColors.defaultTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]
          ],
        ),
        title: ("My Request"),
        activeColorPrimary: MyColors.themeColor,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            print(settings);
            if (settings.name.toString() == '/') {
              print('Login');
            }
          },
          initialRoute: '/',
          routes: Variables.routes,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Widgets.profileWithBorder(20, 'bottom'),
        title: ("Profile"),
        activeColorPrimary: MyColors.themeColor,
        inactiveColorPrimary: Colors.grey,
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          onGenerateRoute: (RouteSettings settings) {
            print(settings.name);
            print(settings);
            if (settings.name.toString() == '/') {
              print('Login');
            }
          },
          initialRoute: '/',
          routes: Variables.routes,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    getData();
  }

  getData() {
    GettingData.getUserReqBill().then((data) {
      setState(() {
        req = data[0]['req'].toString().toInt() +
            data[0]['bill'].toString().toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _pageOptions(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: MyColors.bgColor,
        handleAndroidBackButtonPress: true,
        selectedTabScreenContext: (c) => getData(),
        resizeToAvoidBottomInset: true,
        stateManagement: false,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        margin: EdgeInsets.all(0),
        popActionScreens: PopActionScreensType.all,
        bottomScreenMargin: 0.0,
        hideNavigationBar: false,
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInCirc,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style13,
        onWillPop: (context) {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
              content: Text(
                "Press again to exit",
                textAlign: TextAlign.center,
              ),
            ));
            return Future.value(false);
          }
          return Future.value(true);
        },
      ),
    );
  }
}
