import 'package:chat_app/core/service/api.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:flutter/material.dart';

class ChatInboxViewModel extends BaseViewModel {
  Api _api;

  ChatInboxViewModel({
    @required Api api,
  }) : this._api = api;
}
