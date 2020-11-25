import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  final String authToken;
  BookProvider(this.authToken);
  Future getBooks() async {
    try {
      final response = await http.get(
          "https://book-shop-8a737.firebaseio.com/books.json?auth=$authToken");
      final jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    } catch (error) {
      throw (error);
    }
    // try {
    //   final response =
    //       await http.get('https://api.itbook.store/1.0/search/');
    //   final jsonResponse = convert.jsonDecode(response.body);
    //   // addBookToFirebase();
    //   // print(jsonResponse['books']);
    //   for (var book in jsonResponse['books']) {
    //     addBookToFirebase(book);
    //   }
    //   return jsonResponse;
    // } catch (error) {
    //   print(error);
    //   throw (error);
    // }
  }

  // Future addBookToFirebase(Object book) async {
  //   final url =
  //       "https://book-shop-8a737.firebaseio.com/books.json?auth=$authToken";
  //   final response = await http.post(url, body: convert.jsonEncode(book));
  //   final jsonResponse = convert.jsonDecode(response.body);
  //   print(jsonResponse);
  // }
}
