import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/favorites_provider.dart';
import 'package:fryo/src/shared/colors.dart';
import 'package:fryo/src/shared/styles.dart';
import 'package:provider/provider.dart';

Widget foodItem(
    Product food,
    {double imgWidth = 100,
      onLike,
      onTapped,
      bool isProductPage = false}) {
  return Container(
    width: 180,
    height: 180,
    // color: Colors.red,
    margin: EdgeInsets.only(left: 20),
    child: Stack(
      children: <Widget>[
        Container(
            width: 180,
            height: 180,
            child: ElevatedButton(
                onPressed: onTapped,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: (isProductPage) ? 20 : 12,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Hero(
                    transitionOnUserGestures: true,
                    tag: food.name,
                    child: Image.network(food.imageUrl, width: imgWidth)))),
        Positioned(
          bottom: (isProductPage) ? 10 : 70,
          right: 0,
          child: TextButton(
            onPressed: onLike,
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(20),
              shape: CircleBorder(),
            ),
            child: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                return IconButton(
                  icon: Icon(
                    favoritesProvider.isFavorite(food) ? Icons.favorite : Icons.favorite_border,
                    color: favoritesProvider.isFavorite(food) ? primaryColor : darkText,
                    size: 30,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(food);
                  },
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: (!isProductPage)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(food.name, style: foodNameText),
                    Text(food.price.toStringAsFixed(2), style: priceText),
                  ],
                )
              : Text(' '),
        ),
        Positioned(
            top: 10,
            left: 10,
            child: Container(
                    padding:
                        EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(50)),
                    child: Text('-' + food.discount.toString() + '%',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  )
        )
      ],
    ),
  );
}
