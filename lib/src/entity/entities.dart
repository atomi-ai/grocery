class Store {
  final int id;
  final String name;
  final String address;

  Store({this.id, this.name, this.address});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
    );
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
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.price,
    this.discount,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      price: json['price'],
      discount: json['discount'],
      category: json['category'],
    );
  }
}

class Address {
  final int id;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

  Address({
    this.id,
    this.street,
    this.city,
    this.state,
    this.country,
    this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipCode'] = this.zipCode;
    data['country'] = this.country;
    return data;
  }

  @override
  String toString() {
    return 'Address{id: $id, street: $street, city: $city, state: $state, country: $country, zipCode: $zipCode}';
  }

  static final UNSET_ADDRESS = Address(street: 'UNSET', city: 'UNSET');
}
