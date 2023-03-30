import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/entities.dart';
import '../logic/address_provider.dart';

class NewAddressDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _line1Controller = TextEditingController();
  final _line2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Address'),
      content: SingleChildScrollView(
        child: SizedBox(
          height: 300,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _line1Controller,
                  decoration: InputDecoration(hintText: 'Address Line 1'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _line2Controller,
                  decoration: InputDecoration(hintText: 'Address Line 2'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '(optional))';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(hintText: 'City'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: InputDecoration(hintText: 'State/Province'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter state/province';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _zipCodeController,
                  decoration: InputDecoration(hintText: 'ZIP/Postal Code'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter ZIP/postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _countryController,
                  decoration: InputDecoration(hintText: 'Country'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter country';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              final newAddress = Address(
                line1: _line1Controller.text,
                line2: _line2Controller.text,
                city: _cityController.text,
                state: _stateController.text,
                zipCode: _zipCodeController.text,
                country: _countryController.text,
              );
              final accountProvider =
                  Provider.of<AddressProvider>(context, listen: false);
              accountProvider.addAddress(newAddress);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
