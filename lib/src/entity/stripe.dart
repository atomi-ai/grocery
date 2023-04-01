import 'entities.dart';

class AtomiPaymentMethod {
  final String id;
  final AtomiCard card;
  final AtomiBillingDetails billingDetails;
  final String type;

  AtomiPaymentMethod({
    required this.id,
    required this.card,
    required this.billingDetails,
    this.type = '',
  });

  @override
  String toString() {
    return 'AtomiPaymentMethod{id: $id, card: $card, billingDetails: $billingDetails, type: $type}';
  }

  factory AtomiPaymentMethod.fromJson(Map<String, dynamic> json) {
    return AtomiPaymentMethod(
      id: json['id'],
      card: AtomiCard.fromJson(json['card']),
      billingDetails: AtomiBillingDetails.fromJson(json['billing_details']),
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card': card.toJson(),
      'billing_details': billingDetails.toJson(),
      'type': type,
    };
  }
}

class AtomiBillingDetails {
  final Address address;
  final String email;
  final String phone;

  AtomiBillingDetails({
    required this.address,
    this.email = '',
    this.phone = '',
  });

  @override
  String toString() {
    return 'AtomiBillingDetails{address: $address, email: $email, phone: $phone}';
  }

  factory AtomiBillingDetails.fromJson(Map<String, dynamic> json) {
    return AtomiBillingDetails(
      address: Address.fromJson(json['address']),
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address.toJson(),
      'email': email,
      'phone': phone,
    };
  }
}

class AtomiCard {
  final String brand;
  final String country;
  final int expMonth;
  final int expYear;
  final String last4;

  AtomiCard({
    this.brand = 'visa',
    this.country = 'US',
    required this.expMonth,
    required this.expYear,
    required this.last4,
  });

  @override
  String toString() {
    return 'AtomiCard{brand: $brand, country: $country, expMonth: $expMonth, expYear: $expYear, last4: $last4}';
  }

  factory AtomiCard.fromJson(Map<String, dynamic> json) {
    return AtomiCard(
      brand: json['brand'],
      country: json['country'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      last4: json['last4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'country': country,
      'exp_month': expMonth,
      'exp_year': expYear,
      'last4': last4,
    };
  }
}
