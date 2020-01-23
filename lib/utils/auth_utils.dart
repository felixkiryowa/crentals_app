import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './network_utils.dart';

class AuthUtils {


  static final String endPoint = '/api/v1/authenticate';
  static final String getUserDataEndPoint = '/api/v1/user';

  // Keys to store and fetch data from SharedPreferences
  static final String authTokenKey = 'auth_token';
  static final String userIdKey = 'id';
  static final String firstNameKey = 'firstname';
  static final String lastNameKey = 'lastname';
  static final String mobilenoorEmailKey = 'mobilenoorEmail';



  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static insertDetails(SharedPreferences prefs, var response) {
    prefs.setString(authTokenKey, response['auth_token']);
  }

  static get_logged_user(userAuthToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userRoute = NetworkUtils.developmentHost + getUserDataEndPoint;

    try {
      final response = await http.get(
        userRoute,
        headers: {'Authorization': userAuthToken},
      );

      final responseJson = json.decode(response.body);
      prefs.setInt(userIdKey, responseJson['user']['id']);
      prefs.setString(firstNameKey, responseJson['user']['firstname']);
      prefs.setString(lastNameKey, responseJson['user']['lastname']);
      prefs.setString(mobilenoorEmailKey, responseJson['user']['mobilenoorEmailKey']);
      print(responseJson['user']['lastname']);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}
