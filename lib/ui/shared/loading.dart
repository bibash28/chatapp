import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class Loading {
  static normalLoading() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
      ),
    );
  }
}
