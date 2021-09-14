import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'common/colors.dart';
import 'common/functions.dart';
import 'common/variables.dart' as Variables;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var pref = await Fun.sharedPerf();
  var id = pref.getString("id");

  runApp(
    Phoenix(
      child: MyApp(
        id: id,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final id;

  MyApp({Key? key, this.id}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  {
  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      Variables.userUId = pref.getString('id');
      Variables.username = pref.getString('name');
      Variables.userType = pref.getString('userType');
      Variables.userEmail = pref.getString('email');
      Variables.userAdd = pref.getString('add');
      Variables.number = pref.getString('number');
      Variables.password = pref.getString('pass');
      Variables.userProfile = pref.getString('profile');
      Variables.city = pref.getString('city');
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: MyColors.themeColor,
        statusBarIconBrightness: Brightness.light));
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: MyColors.themeColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              cardColor: MyColors.bgColor,
              scaffoldBackgroundColor: MyColors.bgColor,
              fontFamily: GoogleFonts.robotoSlab().fontFamily,
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              }),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: MyColors.themeColor,
                foregroundColor: MyColors.defaultTextColor,
              ),
            ),
            initialRoute:
            widget.id != null ? Variables.Links.home : Variables.Links.login,
            routes: Variables.routes,
            builder: EasyLoading.init(),
          );
        }
    );
  }
}
