

import '../api/woo_api_client.dart';
import '../database/database.dart';
import '../locator.dart';
import '../model/customer_profile.dart';
import '../locator.dart';
import '../model/product.dart';

class ProductDataSourceImpl extends ProductDataSource {
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<Product> getProducts(int id) => _api.dio
      .get('products/$id')
      .then((response) => Product.fromJson(response.data));

}

abstract class ProductDataSource {
  Future<Product> getProducts(int id);
}