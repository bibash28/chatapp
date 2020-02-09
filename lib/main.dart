import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_app/provider_setup.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/core/service/scroll_behaviour.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/shared/app_colors.dart';

void main() {
  runApp(new MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData themeData = ThemeData(
    primaryColor: AppColor.primaryColor,
    fontFamily: 'Montserrat',
    scaffoldBackgroundColor: AppColor.whiteColor,
    cursorColor: AppColor.primaryColor,
    textTheme: TextTheme(
      body1: TextStyle(
        color: AppColor.darkGrey,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Chat App',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router.generateRoute,
        initialRoute: Router.splashScreen,
        navigatorKey: NavigationService.navigatorKey,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: RemoveScrollGlow(),
            child: child,
          );
        },
      ),
    );
  }
}
