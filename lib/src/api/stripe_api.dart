import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> initStripe() async {
  Stripe.publishableKey = "pk_test_b23w3aM03rrkeOOFbpp2pPWJ";
  // await Stripe.instance.applySettings();
}
