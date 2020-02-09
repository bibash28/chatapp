import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/viewmodel/message/chat_inbox_viewmodel.dart';
import 'package:chat_app/core/viewmodel/user_list_viewmodel.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/loading.dart';
import 'package:chat_app/ui/view/base/base_view.dart';
import 'package:chat_app/ui/view/base/states.dart';
import 'package:chat_app/ui/widget/error_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return BaseView.withConsumer(
      viewModel: UserListViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) => onModelReady(model),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Users"),
          ),
          body: SafeArea(
            child: States(
              model: model,
              loading: Loading.normalLoading(),
              error: ErrorView(
                text: model.serverError,
                onPressed: () => onModelReady(model),
              ),
              idle: body(model),
            ),
          ),
        );
      },
    );
  }


  onModelReady(UserListViewModel model) {}

  body(UserListViewModel model) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return snapshot.data.documents[index]['id'] ==
                        Provider.of<UserModel>(context, listen: false).id
                    ? Container()
                    : Card(
                        color: AppColor.lightestGrey,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 45,
                              width: 45,
                              child: snapshot.data.documents[index]
                                          ['photoUrl'] ==
                                      null
                                  ? Container(
                                      child: Image.asset(
                                        "assets/image/default_pic.jpg",
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: snapshot.data.documents[index]
                                          ['photoUrl'],
                                      placeholder: (context, url) => Container(
                                        color: AppColor.lightGrey,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Text(
                            snapshot.data.documents[index]['email'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: FontSize.m,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data.documents[index]['userName'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                              fontSize: FontSize.s,
                            ),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            model.onTapPeer(
                                Provider.of<UserModel>(context, listen: false),
                                snapshot.data.documents[index]);
                          },
                        ),
                      );
              },
            );
          }
        },
      ),
    );
  }
}
