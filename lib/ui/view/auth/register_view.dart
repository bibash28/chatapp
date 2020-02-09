import 'dart:io';

import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/viewmodel/auth/register_view_model.dart';
import 'package:chat_app/ui/widget/my_text.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/core/service/internetcheck.dart';
import 'package:chat_app/core/viewmodel/auth/login_view_model.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';
import 'package:chat_app/ui/shared/loading.dart';
import 'package:chat_app/ui/shared/ui_helper.dart';
import 'package:chat_app/ui/view/base/base_view.dart';
import 'package:chat_app/ui/view/base/states.dart';
import 'package:chat_app/ui/widget/button.dart';
import 'package:chat_app/ui/widget/error_view.dart';
import 'package:chat_app/ui/widget/logo.dart';
import 'package:chat_app/ui/widget/vertical_spacing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterView createState() => _RegisterView();
}

class _RegisterView extends State<RegisterView> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView.withConsumer(
      viewModel: RegisterViewModel(
        authService: Provider.of(context),
      ),
      onModelReady: (model) => onModelReady(model),
      builder: (context, model, child) {
        return Scaffold(
          key: _scaffoldKey,
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

  onModelReady(RegisterViewModel model) {
    model.setState(ViewState.idle);
  }

  body(RegisterViewModel model) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * UIHelper.screenPadding,
      ),
      children: <Widget>[
        Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                VerticalSpacing(height: 0.15),
                _logo(model),
                VerticalSpacing(height: 0.12),
                _userName(),
                VerticalSpacing(height: 0.01),
                _email(),
                VerticalSpacing(height: 0.01),
                _password(model),
                VerticalSpacing(height: 0.02),
                _termsPolicy(model),
                VerticalSpacing(height: 0.04),
                _register(model),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                _texts(model),
                VerticalSpacing(height: 0.1),
              ],
            ),
          ),
        )
      ],
    );
  }

  _logo(RegisterViewModel model) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(80),
      child: GestureDetector(
        child: model.imagePath != null
            ? Container(
                height: MediaQuery.of(context).size.shortestSide * 0.4,
                width: MediaQuery.of(context).size.shortestSide * 0.4,
                child: Image.file(
                  File(model.imagePath.path),
                  fit: BoxFit.cover,
                ),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.shortestSide * 0.4,
                    width: MediaQuery.of(context).size.shortestSide * 0.4,
                    child: Image.asset(
                      "assets/image/default_pic.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_a_photo,
                        color: AppColor.lightBlack,
                        size: 30,
                      ),
                      MyText("Add Photo"),
                      SizedBox(height: 15),
                    ],
                  )
                ],
              ),
        onTap: () {
          model.getImage();
        },
      ),
    );
  }

  _email() {
    return TextFormField(
      controller: email,
      style: UIHelper.formText(),
      decoration: UIHelper.formDecoration("Email"),
      validator: (value) {
        RegExp regExp = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z]+\.[a-zA-Z]+");
        if (value.isEmpty)
          return "Please enter  your email";
        else if (!regExp.hasMatch(value))
          return "Please enter your valid email";
        return null;
      },
    );
  }

  _userName() {
    return TextFormField(
      controller: userName,
      style: UIHelper.formText(),
      maxLength: 10,
      decoration: UIHelper.formDecoration("UserName"),
      validator: (value) {
        RegExp regExp =
            RegExp(r"^(?!.*[-_]{2,})(?=^[^-_].*[^-_]$)[\w\s-]{3,12}$");
        if (value.isEmpty)
          return "Please enter userName";
        else if (!regExp.hasMatch(value))
          return "Please enter your valid userName";
        return null;
      },
    );
  }

  _password(RegisterViewModel model) {
    return TextFormField(
      controller: password,
      style: UIHelper.formText(),
      obscureText: model.visibility ? false : true,
      decoration: UIHelper.formDecoration("Password").copyWith(
        suffixIcon: IconButton(
          icon: model.visibility
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          onPressed: model.changeVisibility,
        ),
      ),
      validator: (value) {
        if (value.length == 0) {
          return "Please enter your password";
        } else if (value.length < 6) {
          return "Password must be at least 6 characters";
        }
        return null;
      },
    );
  }

  _termsPolicy(RegisterViewModel model) {
    return Row(
      children: <Widget>[
        GestureDetector(
          child: Icon(
            model.marked ? Icons.check_box : Icons.check_box_outline_blank,
            color: model.marked ? AppColor.primaryColor : AppColor.lightGrey,
          ),
          onTap: () => model.onMarkingTap(),
        ),
        SizedBox(width: 15),
        Column(
          children: <Widget>[
            MyText(
              "Agree Terms and Conditions",
              style: TextStyle(
                color: AppColor.normalGrey,
                fontWeight: FontWeight.w500,
                fontSize: FontSize.m,
              ),
              align: TextAlign.justify,
            ),
          ],
        ),
      ],
    );
  }

  _register(RegisterViewModel model) {
    return MyButton(
      text: "Register",
      backColor: AppColor.primaryColor,
      onPressed: () {
        InternetCheck.internetCheck().then(
          (internet) async {
            if (internet != null && internet) {
              if (_formKey.currentState.validate()) {
                if (model.marked) {
                  await model.firebaseRegister(
                      email.text.trim(),
                      password.text.trim(),
                      userName.text.trim(),
                      _scaffoldKey,
                      context);
                } else {
                  showSnackBar(model);
                }
              }
            } else {
              final snackBar = SnackBar(content: Text(UIHelper.noConnection));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          },
        );
      },
    );
  }

  showSnackBar(RegisterViewModel model) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Accept Terms and Conditions"),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {
            model.onMarkingTap();
          },
        ),
      ),
    );
  }

  _texts(RegisterViewModel model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: model.onTapAlreadyHaveAnAccount,
          child: Text(
            "Already Have an Account?",
          ),
        ),
      ],
    );
  }
}
