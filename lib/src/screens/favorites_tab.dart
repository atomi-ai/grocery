import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/favorites_provider.dart';
import '../logic/product_data.dart';
import '../logic/product_provider.dart';
import '../shared/colors.dart';
import 'ProductPage.dart';

class FavoritesTab extends StatelessWidget {
  Widget getItem(bool hidden, Product product, FavoritesProvider favoritesProvider, BuildContext context) {
    Widget item = ListTile(
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
    if (hidden) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(bgColor, BlendMode.saturation),
        child: item,
      );
    } else {
      return item;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    List<Product> favoriteProducts = [];
    for (int favoriteId in favoritesProvider.favorites) {
      favoriteProducts.add(productProvider.productsMap[favoriteId]);
    }
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        return ListView.separated(
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            Product product = favoriteProducts[index];
            return getItem(!productProvider.productIdsInCurrentStore.contains(product.id),
                product, favoritesProvider, context);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        );
      },
    );
  }
}
