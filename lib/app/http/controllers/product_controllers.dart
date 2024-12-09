import 'package:api_vania_mobile/app/models/products_model.dart';
import 'package:api_vania_mobile/app/models/vendors_model.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class ProductControllers extends Controller {
  Future<Response> index() async {
    // final products = await ProductsModel().query().get();
    // final productst = ProductsModel()
    //     .query()
    //     .join('productnotes', 'product.prod_id' '=' 'productnotes.note_id')
    //     .get();
    final products = await ProductsModel()
        .query()
        .join('vendors', 'vendors.vend_id', '=', 'products.vend_id')
        .leftJoin(
            'productnotes', 'productnotes.note_id', '=', 'products.prod_id')
        .select([
      'products.prod_id',
      'products.prod_name',
      'products.prod_price',
      'products.prod_desc',
      'vendors.vend_name as vendor_name',
      'productnotes.note_text as product_note',
      'productnotes.note_date as note_date',
    ]).get();

    return Response.json({"message": "success", "code": 200, "data": products});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'prod_id': 'required|max_length:5',
        'vend_id': 'required|string|max_length:50',
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|string|max_length:20',
        'prod_desc': 'required|string|max_length:5',
      });
      final prodId = request.input('prod_id');
      final vendId = request.input('vend_id');
      final prodName = request.input('prod_name');
      final prodPrice = request.input('prod_price');
      final prodDesc = request.input('prod_desc');

      final vendor = await VendorsModel()
          .query()
          .where('vend_id', '=', request.input('vend_id').toString())
          .first();

      if (vendor == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor not found'}, 404);
      }

      var prodID =
          await ProductsModel().query().where('prod_id', '=', prodId).first();
      if (prodID != null) {
        return Response.json({
          "message": "Data already exist",
          "code": 409,
        });
      }

      final products = await ProductsModel().query().insert({
        "prod_id": prodId,
        "vend_id": vendId,
        "prod_name": prodName,
        "prod_price": prodPrice,
        "prod_desc": prodDesc,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
      return Response.json({
        "message": "Create Customers Success",
        "code": 201,
        "data": products
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
    final products = await ProductsModel()
        .query()
        .where('prod_id', '=', id.toString())
        .first();

    return Response.json(
        {"message": "Vendor Data Founded", "code": 200, "data": products}, 200);
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final products = await ProductsModel()
        .query()
        .where('prod_id', '=', id.toString())
        .first();

    try {
      request.validate({
        'prod_id': 'required|max_length:5',
        'vend_id': 'required|string|max_length:50',
        'prod_name': 'required|string|max_length:50',
        'prod_price': 'required|string|max_length:20',
        'prod_desc': 'required|string|max_length:5',
      });
      final prodId = request.input('prod_id');
      final vendId = request.input('vend_id');
      final prodName = request.input('prod_name');
      final prodPrice = request.input('prod_price');
      final prodDesc = request.input('prod_desc');

      final vendor = await VendorsModel()
          .query()
          .where('vend_id', '=', request.input('vend_id').toString())
          .first();

      if (vendor == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor not found'}, 404);
      }

      await ProductsModel()
          .query()
          .where('prod_id', '=', id.toString())
          .update({
        "prod_id": prodId,
        "vend_id": vendId,
        "prod_name": prodName,
        "prod_price": prodPrice,
        "prod_desc": prodDesc,
        "updated_at": DateTime.now()
      });

      return Response.json({
        "message": "Update Vendors Data Success",
        "code": 200,
        "data": products
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await ProductsModel()
        .query()
        .where('prod_id', '=', id.toString())
        .first();

    if (products == null) {
      return Response.json({
        'message': 'Data Vendors Tidak Ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }

    await ProductsModel().query().where('prod_id', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Data Product Berhasil Dihapus',
      'data': products
    });
  }
}

final ProductControllers productControllers = ProductControllers();
