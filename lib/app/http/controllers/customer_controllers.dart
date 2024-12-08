import 'package:api_vania_mobile/app/models/customers_model.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class CustomerControllers extends Controller {
  Future<Response> index() async {
    final customersList = await CustomersModel().query().get();

    return Response.json(
        {"message": "success", "code": 200, "data": customersList});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_id': 'required|max_length:5',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15'
      });
      final custId = request.input('cust_id');
      final custName = request.input('cust_name');
      final custAddress = request.input('cust_address');
      final custCity = request.input('cust_city');
      final custState = request.input('cust_state');
      final custZip = request.input('cust_zip');
      final custCountry = request.input('cust_country');
      final custTelp = request.input('cust_telp');
      var custID =
          await CustomersModel().query().where('cust_id', '=', custId).first();
      if (custID != null) {
        return Response.json({
          "message": "Data already exist",
          "code": 409,
        });
      }

      final customers = await CustomersModel().query().insert({
        "cust_id": custId,
        "cust_name": custName,
        "cust_address": custAddress,
        "cust_city": custCity,
        "cust_state": custState,
        "cust_zip": custZip,
        "cust_country": custCountry,
        "cust_telp": custTelp,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
      return Response.json({
        "message": "Create Customers Success",
        "code": 201,
        "data": customers
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

  Future<Response> show(dynamic id) async {
    final customer = await CustomersModel()
        .query()
        .where('cust_id', '=', id.toString())
        .first();

    if (customer == null) {
      return Response.json({
        "message": "Customer Data not Found",
        "code": 404,
      }, 404);
    }

    return Response.json(
        {'message': 'Customer Data Founded', 'code': 200, 'data': customer});
  }

  Future<Response> edit(int id) async {
    return Response.json({});
  }

  Future<Response> update(Request request, dynamic id) async {
    final customers = await CustomersModel()
        .query()
        .where('cust_id', '=', id.toString())
        .first();
    try {
      request.validate({
        'cust_id': 'required|max_length:5',
        'cust_name': 'required|string|max_length:50',
        'cust_address': 'required|string|max_length:50',
        'cust_city': 'required|string|max_length:20',
        'cust_state': 'required|string|max_length:5',
        'cust_zip': 'required|string|max_length:7',
        'cust_country': 'required|string|max_length:25',
        'cust_telp': 'required|string|max_length:15'
      });
      final custId = request.input('cust_id');
      final custName = request.input('cust_name');
      final custAddress = request.input('cust_address');
      final custCity = request.input('cust_city');
      final custState = request.input('cust_state');
      final custZip = request.input('cust_zip');
      final custCountry = request.input('cust_country');
      final custTelp = request.input('cust_telp');

      await CustomersModel()
          .query()
          .where('cust_id', '=', id.toString())
          .update({
        "cust_id": custId,
        "cust_name": custName,
        "cust_address": custAddress,
        "cust_city": custCity,
        "cust_state": custState,
        "cust_zip": custZip,
        "cust_country": custCountry,
        "cust_telp": custTelp,
        "updated_at": DateTime.now()
      });

      return Response.json({
        "message": "Update Customers Data Success",
        "code": 200,
        "data": customers
      }, 200);
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(dynamic id) async {
    final customer = await CustomersModel()
        .query()
        .where('cust_id', '=', id.toString())
        .first();

    if (customer == null) {
      return Response.json({
        'message': 'Data Customer Tidak Ditemukan',
        'code': 200,
        'data': customer
      }, 200);
    }

    await CustomersModel().query().where('cust_id', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Data Customer Berhasil Dihapus',
      'data': customer
    });
  }
}

final CustomerControllers customerControllers = CustomerControllers();
