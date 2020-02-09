import 'package:chat_app/core/service/api.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:flutter/material.dart';

class ChatBodyViewModel extends BaseViewModel {
  Api _api;

  ChatBodyViewModel({
    @required Api api,
  }) : this._api = api;

  bool _isLoading = false;

  get isLoading => _isLoading;

  setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
