import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/viewmodel/auth/forgot_password_view_model.dart';
import 'package:chat_app/core/viewmodel/auth/register_view_model.dart';
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

class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordView createState() => _ForgotPasswordView();
}

class _ForgotPasswordView extends State<ForgotPasswordView> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BaseView.withConsumer(
      viewModel: ForgotPasswordViewModel(
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

  onModelReady(ForgotPasswordViewModel model) {
    model.setState(ViewState.idle);
  }

  body(ForgotPasswordViewModel model) {
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
                _logo(),
                VerticalSpacing(height: 0.03),
                _forgotPassword(),
                VerticalSpacing(height: 0.15),
                _email(),
                VerticalSpacing(height: 0.02),
                _send(model),
                VerticalSpacing(height: 0.1),
              ],
            ),
          ),
        )
      ],
    );
  }

  _logo() {
    return MyLogo(
      height: MediaQuery.of(context).size.shortestSide * 0.4,
      width: MediaQuery.of(context).size.shortestSide * 0.4,
    );
  }

  _forgotPassword() {
    return Text(
      "Forgot Password",
      style: TextStyle(
        color: AppColor.primaryColor,
        fontSize: FontSize.xxxxl,
        fontWeight: FontWeight.bold,
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

  _send(ForgotPasswordViewModel model) {
    return MyButton(
      text: "Send Email",
      backColor: AppColor.primaryColor,
      onPressed: () {
        InternetCheck.internetCheck().then(
          (internet) async {
            if (internet != null && internet) {
              if (_formKey.currentState.validate()) {
                model.resetPassword(email.text, _scaffoldKey, context);
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
}
