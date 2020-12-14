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
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      final List book = [];
      jsonResponse.forEach((bookId, bookData) {
        book.add({
          'id': bookId,
          'image': bookData['image'],
          'isbn': bookData['isbn13'],
          'price': bookData['price'],
          'title': bookData['title'],
          'url': bookData['url']
        });
      });
      return book;
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

  Future<dynamic> getBookDetails(var isbn) async {
    final url = "https://api.itbook.store/1.0/books/$isbn";
    try {
      final response = await http.get(url);
      final responseData = convert.jsonDecode(response.body);
      return responseData;
    } catch (error) {
      print(error);
    }
  }
}
