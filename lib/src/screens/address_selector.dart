import 'package:flutter/material.dart';
import 'package:fryo/src/logic/address_provider.dart';
import 'package:provider/provider.dart';
import '../entity/entities.dart';
import 'new_address_dialog.dart';

class AddressSelector extends StatefulWidget {
  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  late Address _selectedAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedAddress = Provider.of<AddressProvider>(context, listen: false).billingAddress;
  }

  void _selectAddress(Address address) {
    setState(() {
      print('xfguo: _selectAddress(), address = ${address}');
      _selectedAddress = address;
    });
  }

  Future<void> _showNewAddressDialog(BuildContext context) async {
    final newAddress = await showDialog<Address>(
      context: context,
      builder: (context) => NewAddressDialog(),
    );
    if (newAddress != null) {
      setState(() {
        // TODO(lamuguo): Add new address to provider.
        _selectedAddress = newAddress;
        print('xfguo: _showNewAddressDialog(), newAddress = ${newAddress}');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addresses = Provider.of<AddressProvider>(context).addresses;
    print('xfguo: addresses = ${addresses}');
    return AlertDialog(
      title: Text('Select billing address'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (final address in addresses)
              ListTile(
                onTap: () {
                  _selectAddress(address);
                  Navigator.of(context).pop(_selectedAddress);
                },
                selected: _selectedAddress == address,
                title: Text('${address.line1} ${address.line2}, ${address.city}'),
                subtitle: Text('${address.state} ${address.zipCode}, ${address.country}'),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Add new address'),
              onPressed: () => _showNewAddressDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
