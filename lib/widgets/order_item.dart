import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders_provider.dart' as ordItem;

class OrderItem extends StatelessWidget {
  final ordItem.OrderItem order;
  OrderItem(this.order){
    print(this.order.amount);
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${order.amount.toStringAsFixed(2)}'),
            subtitle: Text(
              DateFormat('MM/dd/yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
