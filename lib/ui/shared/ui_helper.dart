import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:flutter/material.dart';

class UIHelper {
  static const double borderRadius = 10.0;
  static const double screenPadding = 0.05;

  static String noConnection = "Please Check your Internet Connection";
  static String sthWentWrong = "Oops Something Went Wrong";

  static formText() {
    return TextStyle(
      fontSize: FontSize.xl,
      color: AppColor.darkGrey,
    );
  }

  static formHintText() {
    return TextStyle(
      fontSize: FontSize.xl,
      color: AppColor.normalGrey,
    );
  }

  static texFormStyle() {
    return TextStyle(
      color: AppColor.normalGrey,
      fontSize: FontSize.l,
    );
  }

  static formDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: AppColor.normalGrey,
        fontSize: FontSize.l,
      ),
      counterText: "",
      fillColor: AppColor.whiteColor,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColor.normalGrey,
          width: 1.2,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 20.0,
      ),
    );
  }
}
