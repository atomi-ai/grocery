import 'package:flutter/material.dart';

import './ProductPage.dart';
import '../shared/Product.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import '../shared/partials.dart';
import '../shared/styles.dart';
import '../logic/product_data.dart';

Widget storeTab(BuildContext context) {
  return ListView(children: <Widget>[
    headerTopCategories(),
    deals('Hot Deals',
      onViewMore: () {},
      items: foods.map<Widget>((product) {
        return foodItem(product, onTapped: () {
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
        }, onLike: () {});
      }).toList(),
    ),
    deals('Drinks Parol',
      onViewMore: () {},
      items: drinks.map<Widget>((product) {
        return foodItem(product, onTapped: () {
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
        }, onLike: () {});
      }).toList(),),
  ]);
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: h4),
      ),
      Container(
        margin: EdgeInsets.only(left: 15, top: 2),
        child: TextButton(
          onPressed: onViewMore,
          child: Text('View all ›', style: contrastText),
        ),
      )
    ],
  );
}

// wrap the horizontal listview inside a sizedBox..
Widget headerTopCategories() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      sectionHeader('All Categories', onViewMore: () {}),
      SizedBox(
        height: 130,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: <Widget>[
            headerCategoryItem('Frieds', Fryo.dinner, onPressed: () {}),
            headerCategoryItem('Fast Food', Fryo.food, onPressed: () {}),
            headerCategoryItem('Creamery', Fryo.poop, onPressed: () {}),
            headerCategoryItem('Hot Drinks', Fryo.coffee_cup, onPressed: () {}),
            headerCategoryItem('Vegetables', Fryo.leaf, onPressed: () {}),
          ],
        ),
      )
    ],
  );
}

Widget headerCategoryItem(String name, IconData icon, {onPressed}) {
  return Container(
    margin: EdgeInsets.only(left: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )),
        Text(name + ' ›', style: categoryText)
      ],
    ),
  );
}

Widget deals(String dealTitle, {onViewMore, List<Widget> items}) {
  return Container(
    margin: EdgeInsets.only(top: 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        sectionHeader(dealTitle, onViewMore: onViewMore),
        SizedBox(
          height: 250,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (items != null)
                ? items
                : <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Text('No items available at this moment.',
                    style: taglineText),
              )
            ],
          ),
        )
      ],
    ),
  );
}
