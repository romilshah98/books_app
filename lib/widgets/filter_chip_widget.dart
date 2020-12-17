import 'package:books_app/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChipWidget extends StatefulWidget {
  final String chipName;

  FilterChipWidget({Key key, this.chipName}) : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    var _isSelected = Provider.of<BookProvider>(context).filterState;
    if (_isSelected[widget.chipName] == null) {
      _isSelected[widget.chipName] = false;
    }
    var selectedFilterChip =
        Provider.of<BookProvider>(context).selectedFiltered;
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
        if (selectedFilterChip.contains(widget.chipName)) {
          selectedFilterChip.remove(widget.chipName);
        } else {
          selectedFilterChip.add(widget.chipName);
        }
        setState(() {
          _isSelected[widget.chipName] = isSelected;
          // print(_isSelected);
          // print(selectedFilterChip);
        });
      },
      selectedColor: Color(0xffeadffd),
    );
  }
}
