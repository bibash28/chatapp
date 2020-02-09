import 'dart:async';
import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/service/navigation_service.dart';
import 'package:chat_app/core/viewmodel/message/chat_inbox_viewmodel.dart';
import 'package:chat_app/ui/router.dart';
import 'package:chat_app/ui/shared/loading.dart';
import 'package:chat_app/ui/view/base/base_view.dart';
import 'package:chat_app/ui/view/base/states.dart';
import 'package:chat_app/ui/widget/error_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatInboxView extends StatefulWidget {
  @override
  _ChatInboxViewState createState() => _ChatInboxViewState();
}

class _ChatInboxViewState extends State<ChatInboxView> with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return BaseView.withConsumer(
      viewModel: ChatInboxViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) => onModelReady(model),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            title: Text("Chat App"),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  NavigationService.navigateToAndBack(Router.userListView);
                },
                icon: Icon(
                  Icons.perm_contact_calendar,
                  color: Colors.grey[300],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.location_on,
                  color: Colors.grey[300],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[300],
                ),
              )
            ],
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Start");
    WidgetsBinding.instance.addObserver(this);
  }

  onModelReady(ChatInboxViewModel model) {
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print("App Inactive");
        break;
      case AppLifecycleState.paused:
        print("App Paused");
        break;
      case AppLifecycleState.resumed:
        print("App Resumed");
        break;
      case AppLifecycleState.detached:
        print("App Suspending");
        break;
    }
  }

  body(ChatInboxViewModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              MessageListItem(
                onTap: () {
//                  NavigationService.navigateToAndBack(
//                      Router.chatView,
//                      arguments: model.chatInboxData[i]);
                },
                imagePath:
                    "https://www.remove.bg/assets/start_remove-79a4598a05a77ca999df1dcb434160994b6fde2c3e9101984fb1be0f16d0a74e.png",
                name: Provider.of<UserModel>(context, listen: true).toString(),
                message: "Photo...",
                date: "12:00",
                unread: 1,
                consultationType: "sfasfda",
              ),
              Divider(
                height: 0,
              )
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);;
    print("Stop");
    super.dispose();
  }
}

class MessageListItem extends StatelessWidget {
  final Function onTap;
  final String imagePath;
  final String name;
  final String message;
  final String date;
  final int unread;
  final String consultationType;

  const MessageListItem({
    Key key,
    @required this.onTap,
    @required this.imagePath,
    @required this.name,
    @required this.message,
    @required this.date,
    @required this.consultationType,
    this.unread,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imagePath), fit: BoxFit.fill),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Visibility(
                  visible: (unread != 0 && unread != null) ? true : false,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 2,
                    ),
                    padding: EdgeInsets.only(
                      bottom: 2,
                      left: 7,
                      right: 7,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      unread.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Text(
                  consultationType.toUpperCase(),
                  style: TextStyle(fontSize: 8, color: Colors.deepPurple),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
