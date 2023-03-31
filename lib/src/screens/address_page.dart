import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/address_provider.dart';
import 'new_address_dialog.dart';

class AddressPage extends StatelessWidget {
  final bool is_shipping;

  AddressPage({required this.is_shipping});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AddressProvider>(context, listen: false);
    accountProvider.fetchAddresses();

    return Scaffold(
      appBar: AppBar(
        title: Text('${is_shipping ? 'Shipping' : 'Billing'} Addresses'),
      ),
      body: Consumer<AddressProvider>(
        builder: (context, provider, child) {
          final addresses = provider.addresses;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return Dismissible(
                key: Key(address.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Delete this address?'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  provider.deleteAddress(address.id);
                },
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Set as ${is_shipping ? 'shipping' : 'billing'} address?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text('Set as ${is_shipping ? 'Shipping' : 'Billing'} Address'),
                            onPressed: () {
                              if (is_shipping) {
                                accountProvider.selectShippingAddress(address);
                              } else {
                                accountProvider.selectBillingAddress(address);
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('${address.line1} ${address.line2}, ${address.city}'),
                    subtitle: Text('${address.state} ${address.zipCode}, ${address.country}'),
                    selected: (is_shipping ? provider.shippingAddress?.id : provider.billingAddress?.id) == address.id,
                    selectedTileColor: Colors.yellow,
                    selectedColor: Colors.redAccent,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => NewAddressDialog(),
        ),
      ),
    );
  }
}
