import 'package:books_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookDescriptionScreen extends StatelessWidget {
  final book;
  BookDescriptionScreen(this.book);
  Future<void> _getBookDetails(BuildContext context) async {
    try {
      var details = await Provider.of<BookProvider>(context, listen: false)
          .getBookDetails(book['isbn']);
      print(details);
      return details;
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: FutureBuilder(
        future: _getBookDetails(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print('in future');
            print(snapshot.data);
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
                          child: DataTable(
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
