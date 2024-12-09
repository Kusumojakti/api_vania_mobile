import 'package:api_vania_mobile/app/models/customers_model.dart';
import 'package:api_vania_mobile/app/models/orders_model.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderController extends Controller {
  Future<Response> index() async {
    // final ordersList = await OrdersModel().query().get();
    final ordersList = await OrdersModel()
        .query()
        .join("customers", "customers.cust_id", "=", "orders.cust_id")
        .select([
      "orders.order_num",
      "orders.order_date",
      "customers.cust_name as customers_name",
      "customers.cust_address as customers_address",
      "customers.cust_city as customers_city",
      "customers.cust_country as customers_country",
      "customers.cust_telp as customers_telp"
    ]).get();

    return Response.json(
        {"message": "success", "code": 200, "data": ordersList});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'order_num': 'required|numeric|max_length:11',
        'order_date': 'required|date',
        'cust_id': 'required|string',
      });
      final orderNum = request.input('order_num');
      final orderDate = request.input('order_date');
      final custId = request.input('cust_id');

      final customers = await CustomersModel()
          .query()
          .where('cust_id', '=', request.input('cust_id').toString())
          .first();

      if (customers == null) {
        return Response.json(
            {'success': false, 'message': 'Customers not found'}, 404);
      }

      var ordernum =
          await OrdersModel().query().where('order_num', '=', orderNum).first();
      if (ordernum != null) {
        return Response.json({
          "message": "Data already exist",
          "code": 409,
        });
      }

      final orders = await OrdersModel().query().insert({
        "order_num": orderNum,
        "order_date": orderDate,
        "cust_id": custId,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
      return Response.json(
          {"message": "Create Orders Success", "code": 201, "data": orders},
          201);
    } catch (e) {
      if (e is ValidationException) {
        var errorMessage = e.message;
        return Response.json({"message": errorMessage, "Code": 401}, 401);
      } else {
        return Response.json(
            {"message": "Internal Server error", "code": 500, "data": e}, 500);
      }
    }
  }

  Future<Response> show(int id) async {
    return Response.json({});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, int id) async {
    final orders = await OrdersModel()
        .query()
        .where('order_num', '=', id.toString())
        .first();

    try {
      request.validate({
        'order_num': 'required|numeric|max_length:11',
        'order_date': 'required|date',
        'cust_id': 'required|string',
      });
      final orderNum = request.input('order_num');
      final orderDate = request.input('order_date');
      final custId = request.input('cust_id');

      final customers = await CustomersModel()
          .query()
          .where('cust_id', '=', request.input('cust_id').toString())
          .first();

      if (customers == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor not found'}, 404);
      }

      await OrdersModel()
          .query()
          .where('order_num', '=', id.toString())
          .update({
        "order_num": orderNum,
        "order_date": orderDate,
        "cust_id": custId,
        "updated_at": DateTime.now()
      });

      return Response.json({
        "message": "Update Orders Data Success",
        "code": 200,
        "data": orders
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await OrdersModel()
        .query()
        .where('order_num', '=', id.toString())
        .first();

    if (products == null) {
      return Response.json({
        'message': 'Data Vendors Tidak Ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }

    await OrdersModel().query().where('order_num', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Data Orders Berhasil Dihapus',
      'data': products
    });
  }
}

final OrderController orderController = OrderController();
