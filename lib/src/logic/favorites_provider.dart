import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../entity/entities.dart';

class FavoritesProvider with ChangeNotifier {
  Set<int> _favorites = {};
  Set<int> get favorites => _favorites;

  void addToFavorites(Product product) {
    _favorites.add(product.id);
    log('Added to favorites: ${product.id}');
    log('Current favorites: $_favorites');
    notifyListeners();
  }

  void removeFromFavorites(Product product) {
    _favorites.remove(product.id);
    log('Removed from favorites: ${product.id}');
    log('Current favorites: $_favorites');
    notifyListeners();
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product.id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }
}
