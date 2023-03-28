import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/account_provider.dart';
import 'new_address_dialog.dart';

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    accountProvider.fetchAddresses();

    return Scaffold(
      appBar: AppBar(
        title: Text('Addresses'),
      ),
      body: Consumer<AccountProvider>(
        builder: (context, provider, child) {
          final addresses = provider.addresses;
          return ListView.builder(
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return GestureDetector(
                onTap: () => provider.selectShippingAddress(address),
                child: ListTile(
                  title: Text('${address.street}, ${address.city}'),
                  subtitle: Text('${address.state} ${address.zipCode}, ${address.country}'),
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
