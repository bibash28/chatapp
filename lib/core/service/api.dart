import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  var client = http.Client();

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get('token');
  }

//  Future<UserCheckModel> checkUser(String email) async {
//    String url = emailExist;
//    print("url : $url");
//    try {
//      var response = await http.post(
//        url,
//        body: {
//          'email': email,
//        },
//      );
//      print('The response from email check: ${response.body}');
//      return UserCheckModel.fromJson(jsonDecode(response.body));
//    } catch (e) {
//      print(e);
//      if (e is SocketException) {
//        return UserCheckModel.withError(e.message);
//      } else {
//        return UserCheckModel.withError(e.toString());
//      }
//    }
//  }
//
//  Future<LoginModel> performRegistration(Map data) async {
//    String url = register;
//    print("url : $url");
//    try {
//      var response = await http.post(
//        url,
//        body: data,
//      );
//      print('The response from registration: ${response.body}');
//      return LoginModel.fromJson(jsonDecode(response.body));
//    } catch (e) {
//      if (e is SocketException) {
//        return LoginModel.withError(e.message);
//      } else {
//        return LoginModel.withError(e.toString());
//      }
//    }
//  }
//
//  Future<LoginModel> performLogin(String email, String password) async {
//    String url = login;
//    print("url : $url");
//
//    Map body = {
//      'email': email,
//      'password': password,
//    };
//
//    try {
//      var response = await http.post(
//        url,
//        body: body,
//      );
//      print('The response from login: ${response.body}');
//      return LoginModel.fromJson(jsonDecode(response.body));
//    } catch (e) {
//      if (e is SocketException) {
//        return LoginModel.withError(e.message);
//      } else {
//        return LoginModel.withError(e.toString());
//      }
//    }
//  }
//
//  Future<UserModel> fetchUserData() async {
//    String token = await getToken();
//    String url = user;
//    print("url : $url");
//    try {
//      var response = await http.get(url, headers: {
//        HttpHeaders.authorizationHeader: "Bearer $token",
//        "Content-Type": "application/json",
//      });
//      print('The response from user: ${response.body}');
//      return UserModel.fromJson(jsonDecode(response.body));
//    } catch (e) {
//      if (e is SocketException) {
//        return UserModel.withError(e.message);
//      } else {
//        return UserModel.withError(e.toString());
//      }
//    }
//  }


}