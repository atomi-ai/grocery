class Store {
  final int id;
  final String name;
  final String address;

  Store({required this.id, required this.name, required this.address});

  factory Store.fromJson(Map<String, dynamic> json) {
    print('xfguo: Store.fromJson json = ${json}');
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, address: $address}';
  }
}

class Product {
  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final double price;
  final double discount;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.discount,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'] ?? '',
      price: json['price'],
      discount: json['discount'],
      category: json['category'],
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, imageUrl: $imageUrl, '
        'description: $description, price: $price, discount: $discount, '
        'category: $category)';
  }
}

class Address {
  final int id;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  Address({
    required this.line1,
    required this.city,
    this.id = -1,
    this.line2 = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? -1,
      line1: json['line1'],
      city: json['city'],
      line2: json['line2'] ?? '',
      state: json['state'] ?? 'CA',
      country: json['country'] ?? 'US',
      postalCode: json['postal_code'] ?? '00000',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    return data;
  }

  @override
  String toString() {
    return 'Address{id: $id, line1: $line1, line2: $line2, city: $city, state: $state, country: $country, postalCode: $postalCode}';
  }

  static final UNSET_ADDRESS = Address(line1: 'UNSET', city: 'UNSET');
}
