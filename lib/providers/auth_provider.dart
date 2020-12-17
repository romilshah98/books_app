import 'dart:convert' as convert;
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  Timer _authTime;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get userId{
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

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
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = convert.jsonEncode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
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
      if (jsonResponse['error'] == null) {
        _token = jsonResponse['idToken'];
        _userId = jsonResponse['localId'];
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(jsonResponse['expiresIn']),
          ),
        );
        _autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = convert.jsonEncode({
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        });
        prefs.setString('userData', userData);
      }
      return jsonResponse;
    } catch (error) {
      throw (error);
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        convert.jsonDecode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTime != null) {
      _authTime.cancel();
      _authTime = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTime != null) {
      _authTime.cancel();
    }
    final expiryTime = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTime = Timer(Duration(seconds: expiryTime), logout);
  }
}
