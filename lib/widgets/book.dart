import 'dart:io';

import 'package:books_app/screens/book_description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Book extends StatelessWidget {
  final Map book;
  Book(this.book);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GridTile(
        child: Image.network(
          book['image'],
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            book['title'],
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => BookDescriptionScreen(book))),
    );
  }
}
