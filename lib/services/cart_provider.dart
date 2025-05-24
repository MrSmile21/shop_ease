import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String name;
  final String weight;
  final String description;
  final String price;
  final String imagePath;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.weight,
    required this.description,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalQuantity {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      // Remove 'Rs. ' prefix and convert to double
      final price = double.parse(
          cartItem.price.replaceAll('Rs. ', '').replaceAll(',', ''));
      total += price * cartItem.quantity;
    });
    return total;
  }

  void addItem({
    required String id,
    required String name,
    required String weight,
    required String description,
    required String price,
    required String imagePath,
  }) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          weight: existingCartItem.weight,
          description: existingCartItem.description,
          price: existingCartItem.price,
          imagePath: existingCartItem.imagePath,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          weight: weight,
          description: description,
          price: price,
          imagePath: imagePath,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void decreaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          name: existingCartItem.name,
          weight: existingCartItem.weight,
          description: existingCartItem.description,
          price: existingCartItem.price,
          imagePath: existingCartItem.imagePath,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
