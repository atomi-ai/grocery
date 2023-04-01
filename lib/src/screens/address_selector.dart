import 'package:flutter/material.dart';
import 'package:fryo/src/provider/address_provider.dart';
import 'package:provider/provider.dart';
import '../entity/entities.dart';
import '../shared/atomi_alert_dialog.dart';
import 'new_address_dialog.dart';

class AddressSelector extends StatefulWidget {
  final Address defaultAddress;

  AddressSelector({required this.defaultAddress});

  @override
  _AddressSelectorState createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  late Address _selectedAddress;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedAddress = widget.defaultAddress;
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
    return AtomiAlertDialog(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      title: 'Select billing address',
      content: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('Add new address'),
              onPressed: () => _showNewAddressDialog(context),
            ),
            for (final address in addresses)
              ListTile(
                onTap: () {
                  _selectAddress(address);
                  Navigator.of(context).pop(_selectedAddress);
                },
                selected: _selectedAddress.id == address.id,
                trailing: _selectedAddress.id == address.id ? Icon(Icons.check) : null,
                title: Text('${address.line1} ${address.line2}, ${address.city}'),
                subtitle: Text('${address.state} ${address.zipCode}, ${address.country}'),
              ),
            SizedBox(height: 10),
          ],
        ),
      ), actions: [],
    );
  }
}
