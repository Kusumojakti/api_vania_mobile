import 'package:api_vania_mobile/app/models/orders_item_model.dart';
import 'package:api_vania_mobile/app/models/orders_model.dart';
import 'package:api_vania_mobile/app/models/products_model.dart';
import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';

class OrderItemsControllers extends Controller {
  Future<Response> index() async {
    final orderItems = await OrdersItemModel()
        .query()
        .join("orders", "orders.order_num", "=", "orderitems.order_num")
        .join("customers", "customers.cust_id", "=", "orders.cust_id")
        .leftJoin("products", "products.prod_id", "=", "orderitems.prod_id")
        .select([
      "orderitems.order_item",
      "orderitems.quantity",
      "orderitems.size",
      "products.prod_name as product_name",
      "products.prod_price as product_price",
      "products.prod_desc as product_description",
      "orders.order_date as order_date",
      "customers.cust_name as customer_name",
      "customers.cust_address as customer_address",
      "customers.cust_city as customer_city",
      "customers.cust_country as customer_country",
      "customers.cust_telp as customer_telp"
    ]).get();

    return Response.json(
        {"message": "Success", "code": 200, "data": orderItems}, 200);
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    print(request.all());
    try {
      request.validate({
        'order_item': 'required|numeric|max_length:11',
        'order_num': 'required|numeric|max_length:11',
        'prod_id': 'required|string|max_length:5',
        'quantity': 'required|numeric|max_length:11',
        'size': 'required|numeric|max_length:11'
      });
      final orderItem = request.input('order_item');
      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      final order = await OrdersModel()
          .query()
          .where('order_num', '=', request.input('order_num').toString())
          .first();

      final products = await ProductsModel()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();

      if (products == null) {
        return Response.json(
            {'success': false, 'message': 'Product not found'}, 404);
      } else if (order == null) {
        return Response.json(
            {'success': false, 'message': 'Order not found'}, 404);
      }

      var orderItems = await OrdersItemModel()
          .query()
          .where('order_item', '=', orderItem)
          .first();
      if (orderItems != null) {
        return Response.json({
          "message": "Data already exist",
          "code": 409,
        });
      }

      final orders = await OrdersItemModel().query().insert({
        "order_item": orderItem,
        "order_num": orderNum,
        "prod_id": prodId,
        "quantity": quantity,
        "size": size,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
      return Response.json({
        "message": "Create Orders Item Success",
        "code": 201,
        "data": orders
      }, 201);
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

  Future<Response> update(Request request, dynamic id) async {
    final ordersitem = await OrdersItemModel()
        .query()
        .where('order_item', '=', id.toString())
        .first();

    try {
      request.validate({
        'order_item': 'required|numeric|max_length:11',
        'order_num': 'required|numeric|max_length:11',
        'prod_id': 'required|string|max_length:5',
        'quantity': 'required|numeric|max_length:11',
        'size': 'required|numeric|max_length:11'
      });
      final orderItem = request.input('order_item');
      final orderNum = request.input('order_num');
      final prodId = request.input('prod_id');
      final quantity = request.input('quantity');
      final size = request.input('size');

      final order = await OrdersModel()
          .query()
          .where('order_num', '=', request.input('order_num').toString())
          .first();

      final products = await ProductsModel()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();

      if (products == null) {
        return Response.json(
            {'success': false, 'message': 'Product not found'}, 404);
      } else if (order == null) {
        return Response.json(
            {'success': false, 'message': 'Order not found'}, 404);
      }

      await OrdersItemModel()
          .query()
          .where('order_item', '=', id.toString())
          .update({
        "order_item": orderItem,
        "order_num": orderNum,
        "prod_id": prodId,
        "quantity": quantity,
        "size": size,
        "updated_at": DateTime.now()
      });

      return Response.json({
        "message": "Update Orders Data Success",
        "code": 200,
        "data": ordersitem
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await OrdersItemModel()
        .query()
        .where('order_item', '=', id.toString())
        .first();

    if (products == null) {
      return Response.json({
        'message': 'Data Vendors Tidak Ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }

    await OrdersItemModel().query().where('order_item', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Data Order Items Berhasil Dihapus',
      'data': products
    });
  }
}

final OrderItemsControllers orderItemsControllers = OrderItemsControllers();
