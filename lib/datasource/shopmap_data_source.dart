
import '../api/wp_api_client.dart';
import '../locator.dart';
import '../model/woo_shop.dart';

class ShopMapDataSourceImpl extends ShopMapDataSource {
  final WpApiClient _api = locator<WpApiClient>();
  
  @override
  Future<List<WooGeoShop>> getShops() => _api.dio
      .get('wp/v3/shopmap')
      .then((response) => (response.data as List).map((item) => WooGeoShop.fromJson(item)).toList());
  
}

abstract class ShopMapDataSource {
  Future<List<WooGeoShop>> getShops();
}