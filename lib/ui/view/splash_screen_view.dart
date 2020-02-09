import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/viewmodel/splash_screen_view_model.dart';
import 'package:chat_app/ui/view/base/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/widget/logo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenView createState() => _SplashScreenView();
}

class _SplashScreenView extends State<SplashScreenView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseView.withConsumer(
        viewModel: SplashScreenViewModel(
          authService: Provider.of(context),
        ),
        onModelReady: (SplashScreenViewModel model) async {
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          String uid = await sharedPreferences.get('uid');
          if(uid == null){
            Future.delayed(
              Duration(milliseconds: 2000),
                  () async {
                NavigationService.navigateTo(Router.loginView);
              },
            );
          }else{
            await model.setUpUserModel(uid);
            Future.delayed(
              Duration(milliseconds: 2000),
                  () async {
                NavigationService.navigateTo(Router.chatInboxView);
              },
            );
          }
        },
        builder: (context, model, child) {
          return Scaffold(
            body: Center(
              child: MyLogo(
                height: MediaQuery.of(context).size.shortestSide * 0.4,
                width: MediaQuery.of(context).size.shortestSide * 0.4,
              ),
            ),
          );
        },
      ),
    );
  }
}
