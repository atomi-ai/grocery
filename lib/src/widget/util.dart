import 'package:flutter/material.dart';

import '../entity/entities.dart';

Widget getAddressText(Address t) {
  if (t == null) {
    return Text('null');
  }
  return Text('${t.line1} ${t.line2}, ${t.city}, ${t.state}');
}

