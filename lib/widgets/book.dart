import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class Book extends StatelessWidget {
  final Map book;
  Book(this.book);
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context,listen: false);
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
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart,
          ),
          onPressed: (){
            cart.addItem(this.book['id'],this.book['price'],this.book['title']);
          },
        ),
      ),
    );
  }
}
