import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';
import '../widgets/filter_chip_widget.dart';

class FilterBooks extends StatefulWidget {
  @override
  _FilterBooksState createState() => _FilterBooksState();
}

class _FilterBooksState extends State<FilterBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Books'),
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<BookProvider>(context).filterBooks();
              Navigator.of(context).pop();
            }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Choose Category"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      child: Wrap(
                    spacing: 5.0,
                    runSpacing: 3.0,
                    children: <Widget>[
                      FilterChipWidget(chipName: 'MongoDB'),
                      FilterChipWidget(chipName: 'React'),
                      FilterChipWidget(chipName: 'Angular'),
                      FilterChipWidget(chipName: 'Flutter'),
                      FilterChipWidget(chipName: 'Python'),
                      FilterChipWidget(chipName: 'Java'),
                      FilterChipWidget(chipName: 'JavaScript'),
                      FilterChipWidget(chipName: 'DotNet'),
                      FilterChipWidget(chipName: 'Git'),
                    ],
                  )),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer('Choose Price Range'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      children: <Widget>[
                        FilterChipWidget(chipName: '\$1  to \$10.99'),
                        FilterChipWidget(chipName: '\$11 to \$20.99'),
                        FilterChipWidget(chipName: '\$21 to \$30.99'),
                        FilterChipWidget(chipName: '\$31 to \$40.99'),
                        FilterChipWidget(chipName: '\$41 to \$50.99'),
                        FilterChipWidget(chipName: '\$51 to \$60.99'),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {
                      Provider.of<BookProvider>(context).filterBooks();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Apply Filter',
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 16.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: const TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}
