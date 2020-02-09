import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/widget/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel {
  AuthService _authService;

  LoginViewModel({@required AuthService authService})
      : this._authService = authService;

  bool _visibility = false;

  bool get visibility => _visibility;

  changeVisibility() {
    _visibility = !_visibility;
    notifyListeners();
  }

  firebaseLogin(String email, String password,
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) {
    setState(ViewState.loading);
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((AuthResult authResult) async {
      if (authResult.user.isEmailVerified) {
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .updateData({'verified': true});
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString("uid", authResult.user.uid);
        //put the data into the stream
        await _authService.fetchUserData(authResult.user.uid);
        setState(ViewState.idle);
        NavigationService.navigateTo(Router.chatInboxView);
      } else {
        setState(ViewState.idle);
        dialog(context, authResult, scaffoldKey);
      }
    }).catchError((e) {
      setState(ViewState.idle);
      print("Error $e");
      String error = "";
      if (e is PlatformException) {
        if (e.code == 'ERROR_INVALID_EMAIL') {
          error = "The format of email address is incorrect";
        } else if (e.code == 'ERROR_WRONG_PASSWORD') {
          error = "The password is invalid";
        } else if (e.code == 'ERROR_USER_NOT_FOUND') {
          error = "User not found. Please register.";
        } else if (e.code == "error") {
          error = "Field cannot be empty";
        } else if (e.code == 'ERROR_NETWORK_REQUEST_FAILED') {
          error = "Check your internet connection";
        } else {
          error = "Something went wrong";
        }
        if (error != "") {
          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error)));
        }
      }
    });
  }

  Future<void> dialog(BuildContext context, AuthResult authResult,
      GlobalKey<ScaffoldState> scaffoldKey) {
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
                            "Please verify your email to continue",
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
                          text: "Go Back",
                          onPressed: () => NavigationService.goBack(),
                        ),
                      ),
                      SizedBox(
                          height:
                              MediaQuery.of(context).size.longestSide * 0.02),
                      GestureDetector(
                        child: Text("Resend email"), //Resend Email
                        onTap: () async {
                          NavigationService.goBack();
                          setState(ViewState.loading);
                          try {
                            await authResult.user.sendEmailVerification();
                            setState(ViewState.idle);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text("Verification Email Sent.")));
                          } catch (e) {
                            setState(ViewState.idle);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(
                                    "Failed to send verification email. Try Again later.")));
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  onTapRegisterWithUs() {
    NavigationService.navigateToAndBack(Router.registerView);
  }

  onTapForgotPassword() {
    NavigationService.navigateToAndBack(Router.forgotPasswordView);
  }
}
