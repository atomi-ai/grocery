import 'package:flutter/material.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/shared/atomi_alert_dialog.dart';

class StorePickerDialog extends StatelessWidget {
  final List<Store> stores;

  StorePickerDialog({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AtomiAlertDialog(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      title: 'Select Store',
      content: SingleChildScrollView(
        child: ListBody(
          children: stores.map((store) => ListTile(
            title: Text(store.name),
            subtitle: Text(store.address),
            onTap: () {
              Navigator.of(context).pop(store);
            },
          )).toList(),
        ),
      ), actions: [],
    );
  }
}
