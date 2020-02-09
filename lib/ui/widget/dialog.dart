import 'package:flutter/material.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/ui_helper.dart';
import 'package:chat_app/ui/widget/vertical_spacing.dart';

class MyDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final GestureTapCallback onPressed;

  MyDialog({
    @required this.message,
    @required this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        NavigationService.goBack();
        return;
      },
      child: SimpleDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.borderRadius),
            side: BorderSide(
              color: AppColor.primaryColor,
              width: 3,
            )),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.longestSide * 0.02,
                horizontal: MediaQuery.of(context).size.shortestSide * 0.05),
            child: Column(
              children: <Widget>[
                Wrap(
                  children: <Widget>[
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: FontSize.l,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                VerticalSpacing(height: 0.03),
                InkWell(
                  borderRadius: BorderRadius.circular(UIHelper.borderRadius),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: FontSize.xxl,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: onPressed,
                ),
                VerticalSpacing(height: 0.02),
                Text("Thank You")
              ],
            ),
          )
        ],
      ),
    );
  }
}
