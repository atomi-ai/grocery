import 'package:flutter/foundation.dart';
import 'package:fryo/src/logic/product_provider.dart';

import '../entity/entities.dart';
import 'product_data.dart';

class CartProvider with ChangeNotifier {
  // {productId => quantity}
  Map<int, int> _cartItems = {};
  Map<int, int> get cartItems => _cartItems;

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


  double calculateTotal(cartItems, productIds, allProductmap) {
    double total = 0.0;
    print('xfguo: productsMap = ${allProductmap}');
    cartItems.forEach((productId, quantity) {
      if (!productIds.contains(productId)) {
        return 0.0;
      }
      final product = allProductmap[productId];
      print('xfguo: productId = ${productId}, product = ${product}');
      total += product.price * quantity;
    });
    return total;
  }

  bool cartItemsInCurrentStore(cartItems, productIds) {
    print('xfguo: productIdsInCurrentStore = ${productIds}');
    for (final productId in cartItems.keys) {
      print('xfguo: productId = ${productId}');
      if (!productIds.contains(productId)) {
        print('xfguo: _cartItemsInCurrentStore return false');
        return false;
      }
    }
    print('xfguo: _cartItemsInCurrentStore return true');
    return true;
  }
}
