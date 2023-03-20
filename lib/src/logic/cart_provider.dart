import 'package:flutter/foundation.dart';

import '../shared/Product.dart';

class CartProvider with ChangeNotifier {
  Map<String, int> _cartItems = {};
  Map<String, int> get cartItems => _cartItems;

  void addToCart(Product product, int quantity) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] += quantity;
    } else {
      _cartItems[product.id] = quantity;
    }
    print('Cart items after adding: $_cartItems');
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] -= 1;
      if (_cartItems[product.id] <= 0) {
        _cartItems.remove(product.id);
      }
    }
    print('Cart items after removing: $_cartItems');
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] += 1;
    }
    print('Cart items after incrementing: $_cartItems');
    notifyListeners();
  }

  void decrementQuantity(Product product) {
    if (_cartItems.containsKey(product.id)) {
      _cartItems[product.id] -= 1;
      if (_cartItems[product.id] <= 0) {
        _cartItems.remove(product.id);
      }
    }
    print('Cart items after decrementing: $_cartItems');
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    print('Cart items after clearing: $_cartItems');
    notifyListeners();
  }
}
