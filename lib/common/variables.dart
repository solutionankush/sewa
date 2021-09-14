import 'package:image_picker/image_picker.dart';
import 'package:sewa/ui/admin/voice_req.dart';
import '../ui/admin/add_city.dart';
import '../ui/admin/list_of_cities.dart';

import '../ui/user/bill.dart';
import '../ui/common/profile.dart';

import '../ui/admin/add_service_provider.dart';
import '../ui/admin/admin_home.dart';
import '../ui/admin/list_of_service_provider.dart';
import '../ui/admin/update_about.dart';
import '../ui/common/about_sewa.dart';
import '../ui/common/home.dart';
import '../ui/common/login.dart';
import '../ui/sp/add_service.dart';
import '../ui/sp/list_of_my_services.dart';
import '../ui/sp/request.dart';
import '../ui/sp/sp_home.dart';
import '../ui/user/ReqForm.dart';
import '../ui/user/my_request.dart';
import '../ui/user/user_home.dart';

//for app
var appName = 'Sewa App';


//for user details (SharedPref)
var number, password, username, userUId, userAdd, userEmail, userType, userProfile;

// var bNBKey = Key('bottom');

//for adding SP/User
var name, add, email, mob, city;

//for adding service
var sName, sAbout, sImg;

//for sending request
var reqSid, reqDate, reqTime, reqAdd, reqRemark, reqName;

//all
dynamic isCam, isLoading = false;
final picker = ImagePicker();

//for Routers
var routes = {
  Links.home: (context) => HomePage(),
  Links.login: (context) => Login(),
  Links.about: (context) => AboutSewa(),
  Links.spl: (context) => SPList(),
  Links.addSP: (context) => AddSP(),
  Links.adminHome: (context) => AdminHome(),
  Links.spHome: (context) => SPHome(),
  Links.userHome: (context) => UserHome(),
  Links.service: (context) => ServiceList(),
  Links.addService: (context) => AddService(),
  Links.req: (context) => Request(
        admin: false,
      ),
  Links.myReq: (context) => MyRequest(),
  Links.sendReq: (context) => ReqForm(),
  Links.updateAbout: (context) => UpdateAbout(),
  Links.profile : (context) => Profile(),
  Links.myBills : (context) => Bill(),
  Links.addCity : (context) => AddCity(),
  Links.cityList : (context) => CitiesList(),
  Links.voiceReq : (context) => VoiceReq(),

};

//for links
class Links {
  static final home = '/';
  static final login = 'login';
  static final about = 'about';

  static final spl = 'spl';

  static final voiceReq = 'voiceReq';

  static final addSP = 'addSP';

  static final adminHome = 'adminHome';
  static final spHome = 'spHome';
  static final userHome = 'userHome';

  static final service = 'service';
  static final addService = 'addService';
  static final req = 'serviceReq';

  static final myReq = 'myReq';

  static final sendReq = 'sendReq';

  static final updateAbout = 'updateAbout';
  static final addCity = 'addCity';
  static final cityList = 'city';
  static final profile = 'profile';

  static final myBills = 'myBills';

}

//for images
class Images {
  static final assetsFolder = 'assets';
  static final whatsAppImage = '$assetsFolder/wa.png';
  static final callImage = '$assetsFolder/phone.png';
  static final bannerImage = '$assetsFolder/banner.png';
  static final logoImage = '$assetsFolder/logo.png';
  static final drawerImage = '$assetsFolder/menu.png';
  static final paid = '$assetsFolder/paid.png';
  static final paytm = '$assetsFolder/paytm_logo.png';
  static final cash = '$assetsFolder/cash.png';
}

class Msg {
  static spTOUserMsg(name) {
    var msg = "Dear $name, \nI'm $username Your Vendor in Sewa App. So if you want any type of help regarding any sewa then I'm always here for you";
    return msg;
  }
}