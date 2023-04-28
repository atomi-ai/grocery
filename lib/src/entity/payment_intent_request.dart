const String DEFAULT_CURRENCY = 'usd';

class PaymentIntentRequest {
  final int amount;
  final String currency;
  final int shippingAddressId;
  final String paymentMethodId;
  final int orderId;

  PaymentIntentRequest({
    required this.amount,
    required this.shippingAddressId,
    required this.paymentMethodId,
    required this.orderId,
    this.currency = DEFAULT_CURRENCY,
  });

  factory PaymentIntentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentIntentRequest(
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      shippingAddressId: json['shipping_address_id'] as int,
      paymentMethodId: json['payment_method_id'] as String,
      orderId: json['order_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'shipping_address_id': shippingAddressId,
      'payment_method_id': paymentMethodId,
      'order_id': orderId,
    };
  }

  @override
  String toString() {
    return 'PaymentIntentRequest{amount: $amount, currency: $currency, '
        'shippingAddressId: $shippingAddressId, paymentMethodId: $paymentMethodId}';
  }
}