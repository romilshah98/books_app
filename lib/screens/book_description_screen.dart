import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import 'cart_screen.dart';
import '../providers/book_provider.dart';
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
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: const Text(
              'Something went wrong. Please check your internet connection and try again later!'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quantity =
        Provider.of<CartProvider>(context).getItemCount(book['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (_, cartData, ch) => Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
            ),
            child: IconButton(
              icon: const Padding(
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                                tag: book['id'],
                                child: Image.network(snapshot.data['image']))
                          ],
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Column(
                          children: [
                            DataTable(
                              headingRowHeight: 0,
                              columns: [
                                const DataColumn(label: Text('')),
                                const DataColumn(label: Text('')),
                              ],
                              rows: [
                                DataRow(cells: [
                                  const DataCell(Text(
                                    'Title',
                                    style: TextStyle(fontSize: 13),
                                  )),
                                  DataCell(Text(snapshot.data['title'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Description')),
                                  DataCell(Text(
                                    snapshot.data['desc'],
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Authors')),
                                  DataCell(Text(snapshot.data['authors'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('ISBN')),
                                  DataCell(Text(book['isbn'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Price')),
                                  DataCell(Text(book['price'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Pages')),
                                  DataCell(Text(snapshot.data['pages'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Publisher')),
                                  DataCell(Text(snapshot.data['publisher'])),
                                ]),
                                DataRow(cells: [
                                  const DataCell(Text('Year')),
                                  DataCell(Text(snapshot.data['year'])),
                                ]),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Card(
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
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .addItem(book['id'], book['price'],
                                              book['title']);
                                    },
                                    child: const CircleAvatar(
                                      maxRadius: 16,
                                      child: Text('+'),
                                    ),
                                  ),
                                  CircleAvatar(
                                    maxRadius: 16,
                                    child: Text(quantity.toString()),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (quantity == 0) {
                                        return;
                                      }
                                      if (quantity > 1) {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .reduceItemCount(book['id'],
                                                book['price'], book['title']);
                                      } else {
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .removeItem(book['id']);
                                      }
                                    },
                                    child: const CircleAvatar(
                                      maxRadius: 16,
                                      child: Text('-'),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Could not fetch details! Try again later',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
