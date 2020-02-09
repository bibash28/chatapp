import 'package:flutter/material.dart';
import 'package:chat_app/ui/shared/app_colors.dart';

class ErrorView extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;

  ErrorView({@required this.onPressed, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text),
          RaisedButton(
            child: Text("Retry"),
            onPressed: onPressed,
            textColor: Colors.white,
            color: AppColor.primaryColor,
          )
        ],
      ),
    );
  }
}
