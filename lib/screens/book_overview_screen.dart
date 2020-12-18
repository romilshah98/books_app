import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/book.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/app_drawer.dart';
import './filter_books_screen.dart';

class BookOverviewScreen extends StatefulWidget {
  static const routeName = '/books';

  @override
  _BookOverviewScreenState createState() => _BookOverviewScreenState();
}

class _BookOverviewScreenState extends State<BookOverviewScreen> {
  var _isSearching = false;
  var _isLoading = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<BookProvider>(context, listen: false).getBooks();
      } catch (error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            content: const Text(
                'Something went wrong. Please check you internet connection and try again later!'),
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
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List _books = Provider.of<BookProvider>(context).books;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (text) => {
                  Provider.of<BookProvider>(context, listen: false).search(text)
                },
              )
            : const Text('Books'),
        actions: _isSearching
            ? <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      onPressed: () async {
                        await Provider.of<BookProvider>(context, listen: false)
                            .search('');
                        _controller.text = '';
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                  ],
                ),
              ]
            : <Widget>[
                IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    }),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FilterBooks()));
                  },
                ),
                Consumer<CartProvider>(
                  builder: (_, cartData, ch) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Badge(
                      child: ch,
                      value: cartData.itemCount.toString(),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
              ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _books.length == 0
              ? const Center(child: Text('No Books Found!'))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _books.length,
                  itemBuilder: (ctx, index) => Book(_books[index]),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
    );
  }
}
