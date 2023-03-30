class AtomiPaymentMethod {
  final String id;
  final AtomiCard card;
  final AtomiBillingDetails billingDetails;
  final String type;

  AtomiPaymentMethod({
    this.id,
    this.card,
    this.billingDetails,
    this.type,
  });

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
  final AtomiAddress address;
  final String email;
  final String phone;

  AtomiBillingDetails({
    this.address,
    this.email,
    this.phone,
  });

  factory AtomiBillingDetails.fromJson(Map<String, dynamic> json) {
    return AtomiBillingDetails(
      address: AtomiAddress.fromJson(json['address']),
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

class AtomiAddress {
  final String city;
  final String country;
  final String line1;
  final String line2;
  final String postalCode;
  final String state;

  AtomiAddress({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory AtomiAddress.fromJson(Map<String, dynamic> json) {
    return AtomiAddress(
      city: json['city'],
      country: json['country'],
      line1: json['line1'],
      line2: json['line2'],
      postalCode: json['postal_code'],
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'line1': line1,
      'line2': line2,
      'postal_code': postalCode,
      'state': state,
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
    this.brand,
    this.country,
    this.expMonth,
    this.expYear,
    this.last4,
  });

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
