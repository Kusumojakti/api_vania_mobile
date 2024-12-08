import 'package:api_vania_mobile/app/http/controllers/customer_controllers.dart';
import 'package:api_vania_mobile/app/http/controllers/vendor_controllers.dart';
import 'package:vania/vania.dart';
// import 'package:api_vania_mobile/app/http/controllers/home_controller.dart';
// import 'package:api_vania_mobile/app/http/middleware/authenticate.dart';
// import 'package:api_vania_mobile/app/http/middleware/home_middleware.dart';
// import 'package:api_vania_mobile/app/http/middleware/error_response_middleware.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.resource("/customers", customerControllers);
    Router.resource("/vendors", vendorControllers);

    // Router.get("/home", homeController.index);

    // Router.get("/hello-world", () {
    //   return Response.html('Hello World');
    // }).middleware([HomeMiddleware()]);

    // // Return error code 400
    // Router.get('wrong-request',
    //         () => Response.json({'message': 'Hi wrong request'}))
    //     .middleware([ErrorResponseMiddleware()]);

    // // Return Authenticated user data
    // Router.get("/user", () {
    //   return Response.json(Auth().user());
    // }).middleware([AuthenticateMiddleware()]);
  }
}
