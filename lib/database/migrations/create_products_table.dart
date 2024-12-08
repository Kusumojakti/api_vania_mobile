import 'package:vania/vania.dart';

class CreateProductsTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('products', () {
      char('prod_id', length: 5, unique: true);
      primary('prod_id');
      char('vend_id', length: 5);
      string('prod_name', length: 25);
      integer('prod_price', length: 11);
      text('prod_desc');
      timeStamps();

      foreign('vend_id', 'vendors', 'vend_id',
          constrained: true, onDelete: 'CASCADE');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('products');
  }
}
