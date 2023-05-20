enum PaymentResultStatus { SUCCEEDED, FAILED }

class PaymentResult {
  final PaymentResultStatus result;
  final String? id;
  final String? status;

  PaymentResult({this.id, this.status, required this.result});
}

class Order {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? paymentIntentId;
  final String? deliveryId;
  final List<OrderItem> orderItems;
  final String? displayStatus;

  Order({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.paymentIntentId,
    this.deliveryId,
    required this.orderItems,
    this.displayStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      paymentIntentId: json['payment_intent_id'],
      deliveryId: json['delivery_id'],
      orderItems: List<OrderItem>.from(
          json['order_items'].map((item) => OrderItem.fromJson(item))),
      displayStatus: json['display_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id;
    }
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt!.toIso8601String();
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt!.toIso8601String();
    }
    if (this.paymentIntentId != null) {
      data['payment_intent_id'] = this.paymentIntentId;
    }
    if (this.deliveryId != null) {
      data['delivery_id'] = this.deliveryId;
    }
    data['order_items'] = this.orderItems.map((item) => item.toJson()).toList();
    if (this.displayStatus != null) {
      data['display_status'] = this.displayStatus;
    }
    return data;
  }

  @override
  String toString() {
    return 'Order{id: $id, createdAt: $createdAt, paymentIntentId: $paymentIntentId, deliveryId: $deliveryId,order_itemss: $orderItems}';
  }
}

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['quantity'] = this.quantity;
    return data;
  }

  @override
  String toString() {
    return 'OrderItem{product: $product, quantity: $quantity}';
  }
}

class Store {
  final int id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String phone;

  Store({required this.id, required this.name, required this.address,
  required this.city, required this.state, required this.zipCode, required this.phone});

  factory Store.fromJson(Map<String, dynamic> json) {
    print('xfguo: Store.fromJson json = ${json}');
    return Store(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zip_code'],
      phone: json['phone'],
    );
  }

  @override
  String toString() {
    return 'Store{id: $id, name: $name, address: $address, city: $city, state: $state, zipCode: $zipCode, phone: $phone}';
  }

  String getAddressString() {
    return '$address, $city, $state, $zipCode';
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
      imageUrl: json['image_url'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['description'] = this.description;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['category'] = this.category;
    return data;
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
    this.id = 0,
    this.line2 = '',
    this.state = '',
    this.country = '',
    this.postalCode = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
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

  String getAddressString() {
    return '$line1 $line2, $city, $state, $postalCode';
  }

  static final UNSET_ADDRESS = Address(line1: 'UNSET', city: 'UNSET');
}

class TaxAddress {
  final String state;
  final String postalCode;

  TaxAddress({
    this.state = '',
    required this.postalCode,
  });

  factory TaxAddress.fromJson(Map<String, dynamic> json) {
    return TaxAddress(
      state: json['state'] ?? 'CA',
      postalCode: json['postal_code'] ?? '00000',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    return data;
  }

  @override
  String toString() {
    return 'TaxAddress{state: $state, postalCode: $postalCode}';
  }
}

class TaxInfo {
  final double estimatedCombinedRate;

  TaxInfo({
    required this.estimatedCombinedRate,
  });

  factory TaxInfo.fromJson(Map<String, dynamic> json) {
    return TaxInfo(
      estimatedCombinedRate: json['estimated_combined_rate'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estimated_combined_rate'] = this.estimatedCombinedRate;
    return data;
  }

  @override
  String toString() {
    return 'TaxInfo{estimatedCombinedRate: $estimatedCombinedRate}';
  }
}
