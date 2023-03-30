import 'package:flutter/material.dart';
import 'package:fryo/src/shared/colors.dart';
import 'package:fryo/src/shared/fryo_icons.dart';
import 'package:fryo/src/shared/styles.dart';

import '../entity/entities.dart';
import '../logic/backend_api.dart';
import 'store_picker_dialog.dart';

class DashboardAppBar extends StatelessWidget with PreferredSizeWidget {
  final Store defaultStore;
  final Function(Store) onSelectStore;

  DashboardAppBar({
    Key key,
    this.defaultStore,
    this.onSelectStore,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Atomi',
            style: logoWhiteStyle,
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () => _showStorePicker(context),
            child: FlexibleSpaceBar(
              title: Text(
                defaultStore == null ? 'No Store' : defaultStore.address,
                style: TextStyle(fontSize: 14),
              ),
              centerTitle: true,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.all(0),
          onPressed: () {},
          iconSize: 21,
          icon: Icon(Fryo.alarm),
        )
      ],
    );
  }

  void _showStorePicker(BuildContext context) async {
    final List<Store> stores = await fetchStores();
    final selectedStore = await showDialog<Store>(
      context: context,
      builder: (BuildContext context) {
        return StorePickerDialog(stores: stores);
      },
    );

    if (selectedStore != null) {
      onSelectStore(selectedStore);
    }
  }
}
