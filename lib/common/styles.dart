import 'package:flutter/material.dart';

import 'colors.dart';
import 'converter.dart';

class Styles {
  static formTextStyle() {
    return TextStyle(
      color: MyColors.normalTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w300,
    );
  }

  static headingTextStyle(color) {
    return TextStyle(
      color: color,
      fontSize: 23,
      fontWeight: FontWeight.w700,
    );
  }

  static textFieldDeco(String label, IconData icon) {
    return InputDecoration(
      border: OutlineInputBorder(),

      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 20, right: 15),
        child: Icon(icon, color: MyColors.themeColor),
      ),
      labelText: label,
    );
  }

  static drawerHeaderDeco() {
    return BoxDecoration(
        color: MyColors.themeColor);
  }

  static roundButtonShape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(50.0),
    );
  }

  static roundButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(50.0))),
    );
  }
  static roundCancelButtonStyle() {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(MyColors.badColor),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(50.0))),
    );
  }

  static drawerHeaderText(text, context, textScaleFactor) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor.toString().toDouble(),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: MyColors.defaultTextColor,
          fontSize: 18,
        ),
      ),
    );
  }
}
