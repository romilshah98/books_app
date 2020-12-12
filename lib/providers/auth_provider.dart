import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _email;
  String _password;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  // String get email {
  //   return _email;
  // }

  // String get password {
  //   return _password;
  // }

  Future registerUser(String email, String password) async {
    try {
      const url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDiq4pZqSUhf3KwmTaiVxeaHNZpQ_kln_o";
      final response = await http.post(url,
          body: convert.jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['error'] == null) {
        _token = jsonResponse['idToken'];
        _userId = jsonResponse['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(jsonResponse['expiresIn']),
          ),
        );
        notifyListeners();
      }
      return jsonResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future authenticateUser(String email, String password) async {
    try {
      const url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDiq4pZqSUhf3KwmTaiVxeaHNZpQ_kln_o";
      final response = await http.post(url,
          body: convert.jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final jsonResponse = convert.jsonDecode(response.body);
      // if (jsonResponse['result']) {
      //   _email = email;
      //   _password = password;
      //   // notifyListeners();
      // }
      if (jsonResponse['error'] == null) {
        _token = jsonResponse['idToken'];
        _userId = jsonResponse['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(jsonResponse['expiresIn']),
          ),
        );
        notifyListeners();
      }
      return jsonResponse;
    } catch (error) {
      print(error);
      throw (error);
    }
  }
}
