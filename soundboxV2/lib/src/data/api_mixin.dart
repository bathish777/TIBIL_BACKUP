import 'package:sound_box/src/config/server_config.dart';

mixin ApiMixin {
  Uri createUri(String route, [Map<String, String>? parameters]) =>
      ServerConfig.protocol == 'https'
          ? Uri.https(ServerConfig.serverAddress, route, parameters)
          : Uri.http(ServerConfig.serverAddress, route, parameters);

  Uri createPaymentUri(String route, [Map<String, String>? parameters]) =>
      ServerConfig.protocol == 'https'
          ? Uri.https(ServerConfig.serverAddress, route, parameters)
          : Uri.http(ServerConfig.serverAddress, route, parameters);

  String get applicationJson => 'application/json';

  String get userRouteName => '/user';

  String get paymentRouteName => '/payments';
}
