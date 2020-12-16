import 'package:books_app/screens/filter_books.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/book.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';

class BookOverviewScreen extends StatelessWidget {
  static const routeName = '/books';

  // final AsyncMemoizer _memoizer = AsyncMemoizer();

  _getBooks(BuildContext context) async {
    // return this._memoizer.runOnce(() async {
    try {
      Provider.of<BookProvider>(context).getBooks();
      return true;
    } catch (error) {
      print(error);
      throw(error);
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List _books = Provider.of<BookProvider>(context).books;
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FilterBooks(_books)));
              }),
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Padding(
              padding: EdgeInsets.only(right: 10),
              child: Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
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
            List books = _books;
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
