import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  final String authToken;
  BookProvider(this.authToken);

  List<dynamic> _books = [];
  List<dynamic> _filteredBooks = [];
  List<dynamic> categoriesToFilter = [];
  List<dynamic> pricesToFilter = [];
  List<dynamic> _bookList = [];
  List<dynamic> _finalFilteredBooks = [];
  Map<String, bool> filterState = {};

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
  }

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

  bool isNumeric(String str) {
    if (str == null) {
      return false;
    }
    return double.parse(str, (e) => null) != null;
  }

  filterBooks() {
    _bookList = [];
    _finalFilteredBooks = [];

    // applying category filter
    for (var index = 0; index < categoriesToFilter.length; index++) {
      List books = _books
          .where((book) => book['title'].contains(categoriesToFilter[index]))
          .toList();
      _bookList.addAll(books);
    }
    _finalFilteredBooks.addAll(_bookList);

    // applying price filter on selected categories
    if (_finalFilteredBooks.length > 0) {
      if (pricesToFilter.length > 0) {
        _bookList = [];
        for (var index = 0; index < pricesToFilter.length; index++) {
          List books = _finalFilteredBooks
              .where((book) =>
                  double.parse(pricesToFilter[index].substring(1, 3)) <=
                      double.parse(book['price'].substring(1)) &&
                  double.parse(book['price'].substring(1)) <=
                      double.parse(pricesToFilter[index].substring(8)))
              .toList();
          _bookList.addAll(books);
        }
        _finalFilteredBooks = [..._bookList];
      }
    }

    // applying price filter directly on all books as no category filter selected
    else {
      if (pricesToFilter.length > 0) {
        _bookList = [];
        for (var index = 0; index < pricesToFilter.length; index++) {
          List books = _books
              .where((book) =>
                  double.parse(pricesToFilter[index].substring(1, 3)) <=
                      double.parse(book['price'].substring(1)) &&
                  double.parse(book['price'].substring(1)) <=
                      double.parse(pricesToFilter[index].substring(8)))
              .toList();
          _bookList.addAll(books);
        }
        _finalFilteredBooks.addAll(_bookList);
      }
    }

    // returning filtered books
    if (categoriesToFilter.length > 0 || pricesToFilter.length > 0) {
      _filteredBooks = _finalFilteredBooks;
      notifyListeners();
    } else {
      _filteredBooks = _books;
      notifyListeners();
    }
  }
}
