import 'dart:convert';

import 'package:http/http.dart' as http;
import 'apis.dart';
import '../common/variables.dart' as Variables;

class SearchData {
  static searchServiceByUser(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'serviceByUser',
      'city': Variables.city,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchReqByUser(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'reqByUser',
      'id': Variables.userUId,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchBillByUser(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'billByUser',
      'id': Variables.userUId,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchBillBySp(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'billBySp',
      'id': Variables.userUId,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchServiceBySp(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'serviceBySp',
      'id': Variables.userUId,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchReqBySp(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'reqBySp',
      'id': Variables.userUId,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchServiceByAdmin(value, id) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'serviceByAdmin',
      'id': id,
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchSpByAdmin(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'SpByAdmin',
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchUserByAdmin(value) async {
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'userByAdmin',
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

  static searchCities(value) async{
    var res = await http.post(Api.searchData, body: {
      'searchData' : 'cities',
      'value' : value,
    });
    var data = jsonDecode(res.body);
    return data;
  }

}