class Api {
  // static var server = "http://192.168.42.7/"; // host
  static var server = "https://sunnsunonline.com/ankush_app/"; // host

  static var baseURL = server + "sewa/"; // folder name
  // static var baseURL = server + "sewa_2/sewa/"; // folder name

  // urls of pages;
  static var loginReg = Uri.parse(baseURL + "login_reg.php");

  static var getData = Uri.parse(baseURL + "getting_data.php");
  static var updateData = Uri.parse(baseURL + "update_data.php");
  static var insertData = Uri.parse(baseURL + "insert_data.php");
  static var searchData = Uri.parse(baseURL + "search_data.php");

  static var payment = Uri.parse(baseURL + "payment/txn.php");
  static var paymentResponse = Uri.parse(baseURL + "payment/response.php");
  static var paymentStatus = Uri.parse(baseURL + "payment/check_status.php");

}