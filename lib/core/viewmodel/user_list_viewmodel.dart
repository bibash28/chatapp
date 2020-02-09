import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/service/api.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/core/viewmodel/base_view_model.dart';
import 'package:chat_app/ui/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListViewModel extends BaseViewModel {
  Api _api;

  UserListViewModel({
    @required Api api,
  }) : this._api = api;

  onTapPeer(UserModel myData, DocumentSnapshot peerDataDocument) {
    UserModel peerData = prepareUserJson(peerDataDocument);
    NavigationService.navigateToAndBack(
      Router.chatBodyView,
      arguments: [myData, peerData],
    );
  }

  UserModel prepareUserJson(DocumentSnapshot documents) {
    return UserModel.fromJson({
      "id": documents['id'],
      "email": documents['email'],
      "lat": documents['lat'],
      "lng": documents['lng'],
      "photoUrl": documents['photoUrl'],
      "userName": documents['userName'],
    });
  }
}
