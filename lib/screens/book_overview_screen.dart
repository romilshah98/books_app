import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';

class BookOverviewScreen extends StatelessWidget {
  _getBooks(BuildContext context) async {
    try {
      final response =
          await Provider.of<BookProvider>(context, listen: false).getBooks();
      print(response);
    } catch (error) {
      print(error);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: FutureBuilder(
        future: _getBooks(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text('Books');
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
