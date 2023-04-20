import 'package:flutter/material.dart';
import 'package:fryo/src/api/backend_api.dart';
import 'package:fryo/src/entity/entities.dart';
import 'package:fryo/src/provider/product_provider.dart';
import 'package:fryo/src/provider/store_provider.dart';
import 'package:fryo/src/shared/colors.dart';
import 'package:fryo/src/shared/fryo_icons.dart';
import 'package:fryo/src/shared/styles.dart';
import 'package:fryo/src/widget/store_picker_dialog.dart';
import 'package:provider/provider.dart';

class DashboardAppBar extends StatelessWidget with PreferredSizeWidget {
  DashboardAppBar({Key? key}) : super(key: key);

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
          Consumer<StoreProvider>(
            builder: (context, storeProvider, child) {
              return GestureDetector(
                onTap: () => _showStorePicker(context),
                child: FlexibleSpaceBar(
                  title: Text(
                    storeProvider.defaultStore?.address ?? 'No Store',
                    style: TextStyle(fontSize: 14),
                  ),
                  centerTitle: true,
                ),
              );
            },
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
      await Provider.of<StoreProvider>(context, listen: false)
          .saveDefaultStore(selectedStore);
      await Provider.of<ProductProvider>(context, listen: false)
          .getProducts(selectedStore.id);
    }
  }
}
