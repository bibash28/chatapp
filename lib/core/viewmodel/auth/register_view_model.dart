import 'dart:io';

import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/ui_helper.dart';
import 'package:chat_app/ui/widget/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterViewModel extends BaseViewModel {
  AuthService _authService;

  RegisterViewModel({@required AuthService authService})
      : this._authService = authService;

  bool _visibility = false;

  bool get visibility => _visibility;

  changeVisibility() {
    _visibility = !_visibility;
    notifyListeners();
  }

  bool _marked = false;

  get marked => _marked;

  onMarkingTap() {
    _marked = !marked;
    notifyListeners();
  }

  firebaseRegister(String email, String password, String userName,
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) async {
    setState(ViewState.loading);
    bool emailExist = await checkEmailExistence(email);
    if (!emailExist) {
      bool userNameExist = await checkUserName(userName);
      if (!userNameExist) {
        await registerInFireBase(email, password, userName, scaffoldKey, context);
      } else {
        setState(ViewState.idle);
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("UserName is already in use")));
      }
    } else {
      setState(ViewState.idle);
      scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Email is already in use")));
    }
  }

  Future<bool> checkEmailExistence(String email) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      //email does not exist
      return false;
    } else {
      //email exist
      return true;
    }
  }

  Future<bool> checkUserName(String userName) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('userName', isEqualTo: userName)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      //usename does not exist
      return false;
    } else {
      //username exist
      return true;
    }
  }

  File _imagePath;

  get imagePath => _imagePath;

  Future getImage() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((value) {
      _imagePath = value;
      notifyListeners();
    });
  }

  Future<String> uploadFile(String fileName) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_imagePath);
    StorageTaskSnapshot storageTaskSnapshot;
    String url;
    await uploadTask.onComplete.then((value) async{
      if (value.error == null) {
        storageTaskSnapshot = value;
        await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          print(downloadUrl);
          url = downloadUrl;
        }, onError: (err) {
          //This file is not an image
          print("1");
        });
      } else {
        //This file is not an image
        print("1");
      }
    }, onError: (err) {
      //something went wrong
      print("3");
    });
    return url;
  }

  Future registerInFireBase(String email, String password, String userName,
      GlobalKey<ScaffoldState> scaffoldKey, BuildContext context) async {
    setState(ViewState.loading);
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      try {
        await authResult.user.sendEmailVerification();
        if (authResult.user != null) {
          String image;
          if (_imagePath != null){
            image = await uploadFile(authResult.user.uid + "profilepic");
          }
          // new user
          Firestore.instance
              .collection('users')
              .document(authResult.user.uid)
              .setData({
            'id': authResult.user.uid,
            'userName': userName,
            'email': email,
            'photoUrl': image,
            'lat': "-815.65",
            'lng': "+65.54",
            'verified': false
          });
        }
        setState(ViewState.idle);
        dialog(context, email);
      } catch (e) {
        setState(ViewState.idle);
        scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text("Failed to send verification email")));
      }
    }).catchError((e) {
      setState(ViewState.idle);
      String error = "";
      if (e is PlatformException) {
        if (e.code == 'ERROR_INVALID_EMAIL') {
          error = "The format of email address is incorrect";
        } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          error = "Email is already in use";
        } else if (e.code == 'ERROR_WEAK_PASSWORD') {
          error = "Weak Password";
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
                borderRadius: BorderRadius.circular(UIHelper.borderRadius),
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
                            "We have sent an email to $email email. Please verify to continue.",
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
                          backColor: AppColor.primaryColor,
                          onPressed: () =>
                              NavigationService.navigateTo(Router.loginView),
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

  onTapAlreadyHaveAnAccount() {
    NavigationService.navigateToAndBack(Router.loginView);
  }
}
