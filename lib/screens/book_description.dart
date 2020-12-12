import 'package:flutter/material.dart';

class BookDescriptionScreen extends StatelessWidget {
  final Map book;
  BookDescriptionScreen(this.book);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.network(book['image'])],
            ),
            Divider(),
            Table(
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.3),
              children: [
                TableRow(children: [
                  Column(children: [
                    Text('Title', style: TextStyle(fontSize: 18.0))
                  ]),
                  Column(children: [
                    Text(book['title'], style: TextStyle(fontSize: 18.0))
                  ]),
                ]),
                TableRow(children: [
                  Column(children: [
                    Text('ISBN', style: TextStyle(fontSize: 18.0))
                  ]),
                  Column(children: [
                    Text(book['isbn'], style: TextStyle(fontSize: 18.0))
                  ]),
                ]),
                TableRow(children: [
                  Column(children: [
                    Text('Price', style: TextStyle(fontSize: 18.0))
                  ]),
                  Column(children: [
                    Text(book['price'], style: TextStyle(fontSize: 18.0))
                  ]),
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }
}
