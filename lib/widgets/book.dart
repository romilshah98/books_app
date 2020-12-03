import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Book extends StatelessWidget {
  final Map book;
  Book(this.book);
  @override
  Widget build(BuildContext context) {
    return GridTile(
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
    );
  }
}
