import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/service/internetcheck.dart';
import 'package:chat_app/core/viewmodel/message/chat_body_viewmodel.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/loading.dart';
import 'package:chat_app/ui/view/base/base_view.dart';
import 'package:chat_app/ui/view/base/states.dart';
import 'package:chat_app/ui/widget/error_view.dart';
import 'package:chat_app/ui/widget/my_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBodyView extends StatefulWidget {
  final UserModel myData;
  final UserModel peerData;

  ChatBodyView({this.myData, this.peerData});

  @override
  _ChatBodyViewState createState() => _ChatBodyViewState();
}

class _ChatBodyViewState extends State<ChatBodyView> {
  final TextEditingController message = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  String chatId;
  File imageFile;
  String imageUrl;
  var listMessage;

  @override
  void initState() {
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView.withConsumer(
      viewModel: ChatBodyViewModel(
        api: Provider.of(context),
      ),
      onModelReady: (model) => onModelReady(model),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            title: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 40,
                          height: 40,
                          child: widget.peerData.photoUrl == null
                              ? Image.asset(
                            "assets/image/default_pic.jpg",
                          )
                              : CachedNetworkImage(
                            imageUrl: widget.peerData.photoUrl,
                            placeholder: (context, url) => Container(
                              color: AppColor.lightGrey,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(0.8),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.whiteColor,
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColor.greenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      MyText(
                        widget.peerData.userName,
                        style: TextStyle(
                          fontSize: FontSize.m,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

  onModelReady(ChatBodyViewModel model) {
    //set chatId between me and peer
    if (widget.myData.id.hashCode <= widget.peerData.id.hashCode) {
      chatId = '${widget.myData.id}-${widget.peerData.id}';
    } else {
      chatId = '${widget.peerData.id}-${widget.myData.id}';
    }
  }

  Future getImage(ChatBodyViewModel model) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      model.setLoading(true);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
      FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = reference.putFile(imageFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      storageTaskSnapshot.ref.getDownloadURL().then(
            (downloadUrl) {
          imageUrl = downloadUrl;
          setState(() {
            model.setLoading(false);
            onSendMessage(imageUrl, "image");
          });
        },
        onError: (err) {
          model.setLoading(false);
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("This file is not an image")));
        },
      );
    }
  }

  onSendMessage(String content, String type) {
    if (content.trim() != '') {
      message.clear();
      var documentReference = Firestore.instance
          .collection('messages')
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': widget.myData.id,
            'idTo': widget.peerData.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  body(ChatBodyViewModel model) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),

            // Input content
            buildInput(model),
          ],
        ),

        // Loading
        buildLoading(model)
      ],
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: chatId == ''
          ? Center(
        child: CircularProgressIndicator(
          valueColor:
          AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
        ),
      )
          : StreamBuilder(
        stream: Firestore.instance
            .collection('messages')
            .document(chatId)
            .collection(chatId)
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
              ),
            );
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(
                index,
                snapshot.data.documents[index],
              ),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == widget.myData.id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document['type'] == "text"
          // Text
              ? Container(
            child: Text(
              document['content'],
              style: TextStyle(color: AppColor.primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(
              color: AppColor.lightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
              : document['type'] == "image"
          // Image
              ? Container(
            child: FlatButton(
              child: Material(
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: 200.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      color: AppColor.lightBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Material(
                    child: Image.asset(
                      'assets/image/img_not_available.jpeg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  ),
                  imageUrl: document['content'],
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
//                Navigator.push(
//                    context, MaterialPageRoute(builder: (context) => FullPhoto(url: document['content'])));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                right: 10.0),
          )
          // Video
              : Container(),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                  child: Container(
                    width: 35,
                    height: 35,
                    child: widget.peerData.photoUrl == null
                        ? Image.asset(
                      "assets/image/default_pic.jpg",
                    )
                        : CachedNetworkImage(
                      imageUrl: widget.peerData.photoUrl,
                      placeholder: (context, url) => Container(
                        color: AppColor.lightGrey,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                )
                    : Container(width: 35.0),
                document['type'] == "text"
                    ? Container(
                  child: Text(
                    document['content'],
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : document['type'] == "image"
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            color: AppColor.lightBlue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            Material(
                              child: Image.asset(
                                'assets/image/img_not_available.jpeg',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                        imageUrl: document['content'],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: () {
//                                Navigator.push(
//                                    context,
//                                    MaterialPageRoute(
//                                        builder: (context) => FullPhoto(
//                                            url: document['content'])));
                    },
                    padding: EdgeInsets.all(0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )
                    : Container(),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(document['timestamp']))),
                style: TextStyle(
                    color: AppColor.lightGrey,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] == widget.myData.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] != widget.myData.id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildLoading(ChatBodyViewModel model) {
    return Positioned(
      child: model.isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(AppColor.primaryColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Widget buildInput(ChatBodyViewModel model) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () => getImage(model),
                color: AppColor.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: AppColor.primaryColor, fontSize: 15.0),
                controller: message,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: AppColor.lightGrey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(message.text, "text"),
                color: AppColor.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: AppColor.lightGrey, width: 0.5)),
          color: Colors.white),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
