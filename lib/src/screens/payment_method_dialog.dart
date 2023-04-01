import 'package:flutter/material.dart';
import 'new_payment_method_dialog.dart';
import 'package:provider/provider.dart';

import '../provider/payment_method_provider.dart';

class PaymentMethodDialog extends StatefulWidget {
  const PaymentMethodDialog({Key? key}) : super(key: key);

  @override
  _PaymentMethodDialogState createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final pmProvider = Provider.of<AtomiPaymentMethodProvider>(context, listen: false);
    pmProvider.fetchPaymentMethods();
  }

  // TODO(lamuguo): Add a functionality to delete a payment method.
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('xfguo: window size: ${size}');

    return Dialog(
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: Consumer<AtomiPaymentMethodProvider>(
                builder: (context, provider, child) {
                  final paymentMethods = provider.paymentMethods;
                  final currentPaymentMethodId = provider.currentPaymentMethodId;

                  return ListView.builder(
                    itemCount: paymentMethods.length,
                    itemBuilder: (context, index) {
                      final pm = paymentMethods[index];
                      return ListTile(
                        title: Text(
                            '**** **** **** ${pm.card.last4}'),
                        subtitle: Text(
                            '${pm.card.brand} \n${pm.card.expMonth}/${pm.card.expYear}'),
                        trailing: currentPaymentMethodId == pm.id
                            ? Icon(Icons.check)
                            : null,
                        onTap: () {
                          setState(() {
                            print('xfguo: choose new payment method: ${pm.id}');
                            provider.setCurrentPaymentMethod(pm.id);
                          });
                          Navigator.pop(context, pm.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => NewPaymentMethodDialog(),
                );
              },
              child: Text('Add Payment Method'),
            ),
          ],
        ),
      ),
    );
  }
}
