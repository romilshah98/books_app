import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/book_description_screen.dart';
import '../providers/cart_provider.dart';
import './badge.dart';

class Book extends StatelessWidget {
  final Map book;
  Book(this.book);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final bookCartCount =
        Provider.of<CartProvider>(context).getItemCount(book['id']);
    return GestureDetector(
      child: GridTile(
        child: Hero(
          tag: book['id'],
          child: Image.network(
            book['image'],
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            book['title'],
            textAlign: TextAlign.center,
          ),
          trailing: Badge(
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(
                    this.book['id'], this.book['price'], this.book['title']);
              },
            ),
            value: bookCartCount.toString(),
          ),
        ),
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => BookDescriptionScreen(book))),
    );
  }
}
