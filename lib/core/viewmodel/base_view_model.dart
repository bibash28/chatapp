import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_app/ui/shared/ui_helper.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  String _serverError = UIHelper.noConnection;

  get serverError => _serverError;

  void setServerError(String value) {
    _serverError = value;
    notifyListeners();
  }

  goBack() {
    NavigationService.goBack();
  }
}
