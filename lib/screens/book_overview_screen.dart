import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../widgets/book.dart';

class BookOverviewScreen extends StatelessWidget {
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
      ),
      body: FutureBuilder(
        future: _getBooks(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List books = snapshot.data;
            if (books.length == 0)
              return Center(
                child: Text('No posts found!'),
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
