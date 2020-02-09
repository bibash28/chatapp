import 'package:chat_app/core/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/widget/logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class States extends StatelessWidget {
  final dynamic model;
  final Widget loading;
  final Widget idle;
  final Widget error;

  States(
      {Key key,
      @required this.model,
      @required this.loading,
      @required this.idle,
      @required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body();
  }

  body() {
    switch (model.state) {
      case ViewState.loading:
        return loading;
        break;
      case ViewState.idle:
        return idle;
        break;
      case ViewState.error:
      default:
        return error;
        break;
    }
  }
}
