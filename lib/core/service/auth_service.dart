import 'dart:async';

import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/service/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Api _api;

  AuthService({Api api}) : this._api = api;

  // ignore: close_sinks
  StreamController<UserModel> _userController = StreamController<UserModel>();

  Stream<UserModel> get userController => _userController.stream;

  fetchUserData(String uid) async {
    print(uid);
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: uid)
        .getDocuments();
    final DocumentSnapshot documents = result.documents[0];
    UserModel fetchedUser = prepareUserJson(documents);
    _userController.sink.add(fetchedUser);
    print(fetchedUser.id);
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
