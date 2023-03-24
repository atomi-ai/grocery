import '../entity/entities.dart';

Map<int, Product> productsMap = {};
List<Product> foods = [];
List<Product> drinks = [];
Set<int> productIdsInCurrentStore = {};

void initializeProducts(List<Product> productsList) {
  foods = [];
  drinks = [];
  productIdsInCurrentStore = {};
  productsList.forEach((product) {
    productsMap[product.id] = product;
    productIdsInCurrentStore.add(product.id);
    if (product.category == 'FOOD') {
      foods.add(product);
    } else if (product.category == 'DRINK') {
      drinks.add(product);
    }
  });
}
