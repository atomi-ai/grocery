import 'package:fryo/src/entity/uber.dart';

const String DEFAULT_CURRENCY = 'usd';

class PaymentIntentRequest {
  final int amount;
  final String currency;
  final int shippingAddressId;
  final String paymentMethodId;
  final int orderId;
  final UberDeliveryData? deliveryData;

  PaymentIntentRequest({
    required this.amount,
    required this.shippingAddressId,
    required this.paymentMethodId,
    required this.orderId,
    this.currency = DEFAULT_CURRENCY,
    this.deliveryData,
  });

  factory PaymentIntentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentIntentRequest(
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      shippingAddressId: json['shipping_address_id'] as int,
      paymentMethodId: json['payment_method_id'] as String,
      orderId: json['order_id'] as int,
      deliveryData: UberDeliveryData.fromJson(json['delivery_data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
      'shipping_address_id': shippingAddressId,
      'payment_method_id': paymentMethodId,
      'order_id': orderId,
      'delivery_data': deliveryData?.toJson(),
    };
  }

  @override
  String toString() {
    return 'PaymentIntentRequest{amount: $amount, currency: $currency, '
        'shippingAddressId: $shippingAddressId, paymentMethodId: $paymentMethodId'
        'deliveryData: $deliveryData}';
  }
}