import 'package:api_vania_mobile/app/models/product_notes_model.dart';
import 'package:api_vania_mobile/app/models/products_model.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:vania/vania.dart';

class ProductnotesControllers extends Controller {
  Future<Response> index() async {
    final productsNotes = await ProductNotesModel().query().get();

    return Response.json(
        {"message": "success", "code": 200, "data": productsNotes});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_id': 'required|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });
      final noteId = request.input('note_id');
      final prodId = request.input('prod_id');
      final noteDate = request.input('note_date');
      final noteText = request.input('note_text');

      final products = await ProductsModel()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();

      if (products == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor not found'}, 404);
      }

      var noteID = await ProductNotesModel()
          .query()
          .where('note_id', '=', prodId)
          .first();
      if (noteID != null) {
        return Response.json({
          "message": "Data already exist",
          "code": 409,
        });
      }

      final notes = await ProductNotesModel().query().insert({
        "note_id": noteId,
        "prod_id": prodId,
        "note_date": noteDate,
        "note_text": noteText,
        "created_at": DateTime.now(),
        "updated_at": DateTime.now()
      });
      return Response.json(
          {"message": "Create Notes Success", "code": 201, "data": notes}, 201);
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
    final note = await ProductNotesModel()
        .query()
        .where('note_id', '=', id.toString())
        .first();

    try {
      request.validate({
        'note_id': 'required|max_length:5',
        'prod_id': 'required|string|max_length:10',
        'note_date': 'required|date',
        'note_text': 'required|string',
      });
      final noteId = request.input('note_id');
      final prodId = request.input('prod_id');
      final noteDate = request.input('note_date');
      final noteText = request.input('note_text');

      final prodID = await ProductsModel()
          .query()
          .where('prod_id', '=', request.input('prod_id').toString())
          .first();

      if (prodID == null) {
        return Response.json(
            {'success': false, 'message': 'Vendor not found'}, 404);
      }

      await ProductNotesModel()
          .query()
          .where('note_id', '=', id.toString())
          .update({
        "note_id": noteId,
        "prod_id": prodId,
        "note_date": noteDate,
        "note_text": noteText,
        "updated_at": DateTime.now()
      });

      return Response.json(
          {"message": "Update Notes Data Success", "code": 200, "data": note},
          200);
    } catch (e) {
      return Response.json({
        "message": "Internal Server Error",
        "code": 500,
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    final products = await ProductNotesModel()
        .query()
        .where('note_id', '=', id.toString())
        .first();

    if (products == null) {
      return Response.json({
        'message': 'Data Vendors Tidak Ditemukan',
        'code': 200,
        'data': products
      }, 200);
    }

    await ProductNotesModel().query().where('note_id', '=', id).delete();

    return Response.json({
      'success': true,
      'message': 'Data Notes Berhasil Dihapus',
      'data': products
    });
  }
}

final ProductnotesControllers productnotesController =
    ProductnotesControllers();
