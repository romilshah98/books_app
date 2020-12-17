import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  final String authToken;
  BookProvider(this.authToken);
  List<dynamic> _books = [];
  List<dynamic> _filteredBooks = [];
  List<dynamic> selectedFiltered = [];
  List<dynamic> bookList = [];
  List<dynamic> finalFilteredBooks = [];
  Map<String, bool> filterState = {};
  Set alreadyFiltered = <String>{};

  List get books {
    return [..._filteredBooks];
  }

  Future<void> search(String text) async {
    if (text == '') _filteredBooks = _books;
    text = text.toLowerCase();
    List books = _books
        .where((book) => book['title'].toLowerCase().contains(text))
        .toList();
    _filteredBooks = books;
    notifyListeners();
  }

  Future<void> getBooks() async {
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
      _books = book;
      _filteredBooks = book;
      notifyListeners();
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

  filterBooks() {
    bookList = [];
    finalFilteredBooks = [];
    print(selectedFiltered);
    for (var i = 0; i < selectedFiltered.length; i++) {
      List books = _books
          .where((book) => book['title'].contains(selectedFiltered[i]))
          .toList();
      bookList.add(books);
      print("dksf");
      if (bookList.length != i + 1) {
        print("dksf");
        print(double.parse(_books[0]['price'].substring(1)) <
            double.parse(selectedFiltered[i].substring(8)));
        List books = _books
            .where((book) =>
                double.parse(book['price'].substring(1)) <
                double.parse(selectedFiltered[i].substring(8)))
            .toList();
        bookList.add(books);
      }
    }
    for (var i = 0; i < bookList.length; i++) {
      for (var j = 0; j < bookList[i].length; j++) {
        finalFilteredBooks.add(bookList[i][j]);
      }
    }
    if (selectedFiltered.length > 0) {
      _filteredBooks = finalFilteredBooks;
      notifyListeners();
    } else {
      _filteredBooks = _books;
      notifyListeners();
    }
  }
}
