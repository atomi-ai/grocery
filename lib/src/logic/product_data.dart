
import '../entity/entities.dart';

Map<String, Product> productsMap = {};
List<Product> foods = [];
List<Product> drinks = [];

void initializeProducts(List<Product> productsList) {
  productsMap = {};
  foods = [];
  drinks = [];
  productsList.forEach((product) {
    productsMap[product.id.toString()] = product;
    if (product.category == 'FOOD') {
      foods.add(product);
    } else if (product.category == 'DRINK') {
      drinks.add(product);
    }
  });
}
