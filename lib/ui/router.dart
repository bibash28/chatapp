import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/ui/view/auth/forgot_password_view.dart';
import 'package:chat_app/ui/view/auth/register_view.dart';
import 'package:chat_app/ui/view/message/chat_body.dart';
import 'package:chat_app/ui/view/message/chat_inbox.dart';
import 'package:chat_app/ui/view/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/ui/view/auth/login_view.dart';
import 'package:chat_app/ui/view/splash_screen_view.dart';

class Router {
  static const String splashScreen = "splashScreen";
  static const String loginView = "loginView";
  static const String registerView = "registerView";
  static const String forgotPasswordView = "forgotPasswordView";
  static const String chatInboxView = "chatInboxView";
  static const String chatBodyView = "chatBodyView";
  static const String userListView = "userListView";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreenView(),
        );

      case loginView:
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );

      case registerView:
        return MaterialPageRoute(
          builder: (_) => RegisterView(),
        );

      case forgotPasswordView:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordView(),
        );

      case chatInboxView:
        return MaterialPageRoute(
          builder: (_) => ChatInboxView(),
        );

      case chatBodyView:
        List<UserModel> data = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => ChatBodyView(myData: data[0], peerData: data[1]),
          settings: RouteSettings(name: settings.name),
        );

      case userListView:
        return MaterialPageRoute(
          builder: (_) => UserListView(),
        );

//      case buyCreditView:
//        var data = settings.arguments as bool;
//        return MaterialPageRoute(
//          builder: (_) => BuyCreditView(flag: data),
//          settings: RouteSettings(name: settings.name),
//        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text("No route defined for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
