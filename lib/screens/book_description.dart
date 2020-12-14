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
        title: Text('title'),
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
                  Divider(),
                  Table(
                    border: TableBorder.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 0.3),
                    children: [
                      TableRow(children: [
                        Column(children: [
                          Text('Title', style: TextStyle(fontSize: 18.0))
                        ]),
                        Column(children: [
                          Text(snapshot.data['title'],
                              style: TextStyle(fontSize: 18.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: [
                          Text('ISBN', style: TextStyle(fontSize: 18.0))
                        ]),
                        Column(children: [
                          Text(book['isbn'],
                              style: TextStyle(fontSize: 18.0))
                        ]),
                      ]),
                      TableRow(children: [
                        Column(children: [
                          Text('Price', style: TextStyle(fontSize: 18.0))
                        ]),
                        Column(children: [
                          Text(book['price'],
                              style: TextStyle(fontSize: 18.0))
                        ]),
                      ]),
                    ],
                  )
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
