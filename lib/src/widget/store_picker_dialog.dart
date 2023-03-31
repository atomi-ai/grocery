import 'package:flutter/material.dart';

import '../entity/entities.dart';

class StorePickerDialog extends StatelessWidget {
  final List<Store> stores;

  StorePickerDialog({Key? key, required this.stores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Store'),
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
      ),
    );
  }
}
