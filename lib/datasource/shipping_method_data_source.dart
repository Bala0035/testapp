
import '../api/woo_api_client.dart';
import '../locator.dart';
import '../model/shipping_method.dart';

class ShippingMethodDataSourceImpl extends ShippingMethodDataSource {

  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<ShippingMethod>> getShippingMethods() => _api.dio
      .get('shipping_methods')
      .then((response) => (response.data as List).map((item) => ShippingMethod.fromJson(item)).toList());

}

abstract class ShippingMethodDataSource {
  Future<List<ShippingMethod>> getShippingMethods();
}