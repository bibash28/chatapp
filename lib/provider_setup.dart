import 'package:chat_app/core/model/auth/user_model.dart';
import 'package:chat_app/core/service/api.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders
];

List<SingleChildWidget> independentServices = [
  Provider.value(value: Api())
];

List<SingleChildWidget> dependentServices = [
  ProxyProvider<Api, AuthService>(
    update: (_, api, __) => AuthService(api: api),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
  StreamProvider<UserModel>(
    create: (context) => Provider.of<AuthService>(context, listen: false).userController,
    updateShouldNotify: (_, __) => true,
  ),
];
