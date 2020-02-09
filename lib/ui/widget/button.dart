import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/ui/shared/font_size.dart';

class MyButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final Color backColor;

  MyButton(
      {@required this.text,
      this.onPressed,
      this.backColor = AppColor.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: FontSize.xxl,
            fontWeight: FontWeight.w600,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        color: backColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed,
      ),
    );
  }
}
