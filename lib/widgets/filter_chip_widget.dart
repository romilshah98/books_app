import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/book_provider.dart';

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

bool isNumeric(String str) {
  if (str == null) {
    return false;
  }
  return double.parse(str, (e) => null) != null;
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  
  @override
  Widget build(BuildContext context) {
    var _isSelected = Provider.of<BookProvider>(context).filterState;
    if (_isSelected[widget.chipName] == null) {
      _isSelected[widget.chipName] = false;
    }
    var categoriesToFilter =
        Provider.of<BookProvider>(context).categoriesToFilter;
    var pricesToFilter = Provider.of<BookProvider>(context).pricesToFilter;
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
          if (pricesToFilter.contains(widget.chipName)) {
            pricesToFilter.remove(widget.chipName);
          } else {
            pricesToFilter.add(widget.chipName);
          }
        } else {
          if (categoriesToFilter.contains(widget.chipName)) {
            categoriesToFilter.remove(widget.chipName);
          } else {
            categoriesToFilter.add(widget.chipName);
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
