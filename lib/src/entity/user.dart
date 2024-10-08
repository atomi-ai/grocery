class User {
  final int id;
  final String email;
  final String role;
  final String phone;
  final String name;
  final int defaultShippingAddressId;
  final int defaultBillingAddressId;
  final String stripeCustomerId;
  final String paymentMethodId;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.phone = '',
    this.name = '',
    this.defaultShippingAddressId = -1,
    this.defaultBillingAddressId = -1,
    this.stripeCustomerId = '',
    this.paymentMethodId = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      defaultShippingAddressId: json['default_shipping_address_id'] ?? -1,
      defaultBillingAddressId: json['default_billing_address_id'] ?? -1,
      stripeCustomerId: json['stripe_customer_id'] ?? '',
      paymentMethodId: json['payment_method_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'phone': phone,
      'name': name,
      'default_shipping_address_id': defaultShippingAddressId,
      'default_billing_address_id': defaultBillingAddressId,
      'stripe_customer_id': stripeCustomerId,
      'payment_method_id': paymentMethodId,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, phone: $phone, '
        'name: $name, defaultShippingAddressId: $defaultShippingAddressId, '
        'defaultBillingAddressId: $defaultBillingAddressId, '
        'stripeCustomerId: $stripeCustomerId, paymentMethodId: $paymentMethodId)';
  }
}



