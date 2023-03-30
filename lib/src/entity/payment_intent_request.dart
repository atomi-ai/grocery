const String DEFAULT_CURRENCY = 'usd';

class PaymentIntentRequest {
  final int amount;
  final String currency;
  final int shippingAddressId;
  final String paymentMethodId;

  PaymentIntentRequest({
    this.amount,
    this.currency = DEFAULT_CURRENCY,
    this.shippingAddressId,
    this.paymentMethodId});

  factory PaymentIntentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentIntentRequest(
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      shippingAddressId: json['shipping_address_id'] as int,
      paymentMethodId: json['payment_method_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'shipping_address_id': shippingAddressId,
      'payment_method_id': paymentMethodId,
    };
  }

  @override
  String toString() {
    return 'PaymentIntentRequest{amount: $amount, currency: $currency, '
        'shippingAddressId: $shippingAddressId, paymentMethodId: $paymentMethodId}';
  }
}