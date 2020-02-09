import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/ui_helper.dart';
import 'package:chat_app/ui/widget/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  AuthService _authService;

  ForgotPasswordViewModel({@required AuthService authService})
      : this._authService = authService;

  Future<void> resetPassword(String email, GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) async {
    setState(ViewState.loading);
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .then((user) async {
      setState(ViewState.idle);
      dialog(context, email);
    }).catchError((e) {
      String error = "";
      if (e is PlatformException) {
        if (e.code == 'ERROR_USER_NOT_FOUND') {
          error = "Error User Not Found";
        } else if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
          error = "Check your internet connection";
        } else if (e.code == 'ERROR_INVALID_EMAIL') {
          error = "The format of email address is incorrect";
        }
      }

      setState(ViewState.idle);
      final snackBar = SnackBar(content: Text(error));
      scaffoldKey.currentState.showSnackBar(snackBar);
    });
  }

  Future<void> dialog(BuildContext context, String email) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return;
            },
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: AppColor.primaryColor,
                  width: 3,
                ),
              ),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.longestSide * 0.02,
                      horizontal:
                      MediaQuery.of(context).size.shortestSide * 0.05),
                  child: Column(
                    children: <Widget>[
                      Wrap(
                        children: <Widget>[
                          Text(
                            "Password Change verification email sent to  $email",
                            style: TextStyle(
                                fontSize: FontSize.xl,
                                fontWeight: FontWeight.w600,
                                color: AppColor.darkGrey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                          MediaQuery.of(context).size.longestSide * 0.04),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: MyButton(
                          text: "Continue",
                          onPressed: () => NavigationService.navigateTo(
                              Router.loginView),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

}
