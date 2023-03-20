import '../shared/Product.dart';

Map<String, Product> productsMap = {};

void _initializeProducts(List<Product> productsList) {
  productsList.forEach((product) {
    productsMap[product.id] = product;
  });
}

void initProducts() {
  _initializeProducts(foods);
  _initializeProducts(drinks);
}

// will pick it up from here
// am to start another template
List<Product> foods = [
  Product(
    id: "food_0001",
      name: "Hamburger",
      image: "images/3.png",
      price: 25,
      userLiked: true,
      discount: 10),
  Product(
      id: "food_0002",
      name: "Pasta",
      image: "images/5.png",
      price: 150,
      userLiked: false,
      discount: 7.8),
  Product(
    id: "food_0003",
    name: "Akara",
    image: 'images/2.png',
    price: 10.99,
    userLiked: false,
  ),
  Product(
      id: "food_0004",
      name: "Strawberry",
      image: "images/1.png",
      price: 50,
      userLiked: true,
      discount: 14)
];

List<Product> drinks = [
  Product(
      id: "drink_0001",
      name: "Coca-Cola",
      image: "images/6.png",
      price: 45.12,
      userLiked: true,
      discount: 2),
  Product(
      id: "drink_0002",
      name: "Lemonade",
      image: "images/7.png",
      price: 28,
      userLiked: false,
      discount: 5.2),
  Product(
      id: "drink_0003",
      name: "Vodka",
      image: "images/8.png",
      price: 78.99,
      userLiked: false),
  Product(
      id: "drink_0004",
      name: "Tequila",
      image: "images/9.png",
      price: 16899999,
      userLiked: true,
      discount: 3.4)
];
