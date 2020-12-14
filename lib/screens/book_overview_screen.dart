import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/book.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

class BookOverviewScreen extends StatelessWidget {
  static const routeName = '/books';
  _getBooks(BuildContext context) async {
    try {
      final response =
          await Provider.of<BookProvider>(context, listen: false).getBooks();
      return response;
    } catch (error) {
      print(error);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _getBooks(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List books = snapshot.data;
            if (books.length == 0)
              return Center(
                child: Text('No book found!'),
              );
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: books.length,
              itemBuilder: (ctx, index) => Book(books[index]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          }
        },
      ),
    );
  }
}
