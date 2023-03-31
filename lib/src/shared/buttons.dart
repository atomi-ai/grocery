import 'package:flutter/material.dart';
import './colors.dart';

TextButton froyoFlatBtn(String text, onPressed) {
  return TextButton(
    onPressed: onPressed,
    child: Text(text),
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}

OutlinedButton froyoOutlineBtn(String text, onPressed) {
  return OutlinedButton(
    onPressed: onPressed,
    child: Text(text),
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor, // 文字颜色
      backgroundColor: Colors.transparent, // 按钮背景颜色
      side: BorderSide(color: primaryColor), // 边框颜色
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), // 圆角形状
    ),
  );
}
