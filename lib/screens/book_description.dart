import 'package:books_app/providers/book_provider.dart';
import 'package:books_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import './cart_screen.dart';
import '../providers/cart_provider.dart';

class BookDescriptionScreen extends StatelessWidget {
  final book;
  BookDescriptionScreen(this.book);

  Future<void> _getBookDetails(BuildContext context) async {
    try {
      var details = await Provider.of<BookProvider>(context, listen: false)
          .getBookDetails(book['isbn']);
      return details;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity =
        Provider.of<CartProvider>(context).getItemCount(book['id']);
    print(quantity);
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
            ),
            child: IconButton(
              icon: Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.shopping_cart)),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getBookDetails(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Image.network(snapshot.data['image'])],
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                      child: ListView(
                    children: [
                      SingleChildScrollView(
                          child: Column(
                        children: [
                          DataTable(
                            headingRowHeight: 0,
                            columns: [
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text(
                                  'Title',
                                  style: TextStyle(fontSize: 13),
                                )),
                                DataCell(Text(snapshot.data['title'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Description')),
                                DataCell(Text(
                                  snapshot.data['desc'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Authors')),
                                DataCell(Text(snapshot.data['authors'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('ISBN')),
                                DataCell(Text(book['isbn'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Price')),
                                DataCell(Text(book['price'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Pages')),
                                DataCell(Text(snapshot.data['pages'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Publisher')),
                                DataCell(Text(snapshot.data['publisher'])),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Year')),
                                DataCell(Text(snapshot.data['year'])),
                              ]),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Add to Cart',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  color: Colors.blue,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   quantity = quantity + 1;
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addItem(book['id'], book['price'],
                                            book['title']);
                                    // });
                                  },
                                  child: CircleAvatar(
                                    maxRadius: 16,
                                    child: Text('+'),
                                  ),
                                ),
                                CircleAvatar(
                                  maxRadius: 16,
                                  child: Text(quantity.toString()),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ))
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not fetch details! Try again later',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
