import 'package:vania/vania.dart';
import 'package:api_vania_mobile/route/api_route.dart';
import 'package:api_vania_mobile/route/web.dart';
import 'package:api_vania_mobile/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}
