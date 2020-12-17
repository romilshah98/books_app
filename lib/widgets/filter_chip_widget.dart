import 'package:books_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    var _isSelected = Provider.of<BookProvider>(context).filterState;
    if (_isSelected[widget.chipName] == null) {
      _isSelected[widget.chipName] = false;
    }
    var filterByCategory =
        Provider.of<BookProvider>(context).categoriesToFilter;
    var filterByPrice = Provider.of<BookProvider>(context).pricesToFilter;
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: TextStyle(
          color: Color(0xff6200ee),
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      selected: _isSelected[widget.chipName],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        if (isNumeric(widget.chipName.substring(1, 3))) {
          if (filterByPrice.contains(widget.chipName)) {
            filterByPrice.remove(widget.chipName);
          } else {
            filterByPrice.add(widget.chipName);
          }
        } else {
          if (filterByCategory.contains(widget.chipName)) {
            filterByCategory.remove(widget.chipName);
          } else {
            filterByCategory.add(widget.chipName);
          }
        }
        setState(() {
          _isSelected[widget.chipName] = isSelected;
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
