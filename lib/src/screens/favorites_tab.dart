import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/favorites_provider.dart';
import '../logic/product_data.dart';
import 'ProductPage.dart';

class FavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FavoritesProvider _favoritesProvider =
    Provider.of<FavoritesProvider>(context, listen: false);

    List<Product> favoriteProducts = [];
    for (int favoriteId in _favoritesProvider.favorites) {
      favoriteProducts.add(productsMap[favoriteId]);
    }
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {

        return ListView.separated(
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            Product product = favoriteProducts[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: IconButton(
                icon: favoritesProvider.isFavorite(product)
                    ? Icon(Icons.favorite, color: Colors.red)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  favoritesProvider.toggleFavorite(product);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return new ProductPage(
                        productData: product,
                      );
                    },
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        );
      },
    );
  }
}
