import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenViewModel extends BaseViewModel {
  AuthService _authService;

  SplashScreenViewModel({@required AuthService authService})
      : this._authService = authService;


  setUpUserModel(String uid) async{
    await _authService.fetchUserData(uid);
  }
}
