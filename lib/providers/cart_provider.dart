import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String bookId, String price, String title) {
    price = price.substring(1);

    if (_items.containsKey(bookId)) {
      _items.update(
        bookId,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        bookId,
        () => CartItem(
          id: bookId,
          title: title,
          price: double.parse(price),
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void reduceItemCount(String bookId, String price, String title) {
    price = price.substring(1);
    _items.update(
      bookId,
      (existingItem) => CartItem(
        id: existingItem.id,
        title: existingItem.title,
        price: existingItem.price,
        quantity: existingItem.quantity - 1,
      ),
    );
    notifyListeners();
  }

  void removeItem(String bookId) {
    _items.remove(bookId);
    notifyListeners();
  }

  int getItemCount(String id) {
    if (_items.containsKey(id)) {
      return _items[id].quantity;
    } else {
      return 0;
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
