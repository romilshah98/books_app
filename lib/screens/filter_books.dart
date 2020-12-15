import 'package:flutter/material.dart';
import '../widgets/filter_chip_widget.dart';

class FilterBooks extends StatefulWidget {
  final books;
  FilterBooks(this.books);
  @override
  _FilterBooksState createState() => _FilterBooksState();
}

class _FilterBooksState extends State<FilterBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Books'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
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
                    FilterChipWidget(chipName: 'Python'),
                    FilterChipWidget(chipName: 'Java'),
                    FilterChipWidget(chipName: 'JavaScript'),
                    FilterChipWidget(chipName: '.NET'),
                    FilterChipWidget(chipName: 'Git'),
                  ],
                )),
              ),
            ),
            Divider(
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
                      FilterChipWidget(chipName: '\$0 to \$20.99'),
                      FilterChipWidget(chipName: '\$21 to \$40.99'),
                      FilterChipWidget(chipName: '\$41 to \$60.99'),
                      FilterChipWidget(chipName: 'Above \$60'),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
              height: 10.0,
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}
