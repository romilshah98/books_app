import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> books;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.books,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  final String authToken;
  final String userId;

  OrdersProvider(this.authToken, this.userId);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    try {
      final url =
          "https://book-shop-8a737.firebaseio.com/orders/$userId.json?auth=$authToken";
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse == null) {
        return;
      }
      jsonResponse.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            dateTime: DateTime.parse(orderData['dateTime']),
            amount: orderData['amount'],
            books: (orderData['books'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addOrder(List<CartItem> cartBooks, double total) async {
    try {
      final url =
          "https://book-shop-8a737.firebaseio.com/orders/$userId.json?auth=$authToken";
      final timeStamp = DateTime.now();
      final response = await http.post(url,
          body: convert.jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'books': cartBooks
                .map((cartBook) => {
                      'id': cartBook.id,
                      'title': cartBook.title,
                      'quantity': cartBook.quantity,
                      'price': cartBook.price,
                    })
                .toList(),
          }));
      final jsonResponse = convert.jsonDecode(response.body);
      _orders.insert(
        0,
        OrderItem(
          id: jsonResponse['name'],
          amount: total,
          dateTime: timeStamp,
          books: cartBooks,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
