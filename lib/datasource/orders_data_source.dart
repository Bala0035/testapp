

import '../api/woo_api_client.dart';
import '../constants/config.dart';
import '../database/database.dart';
import '../locator.dart';
import '../model/customer_profile.dart';
import '../model/order.dart';

class OrdersDataSourceImpl extends OrdersDataSource {
  final WooApiClient _api = locator<WooApiClient>();
  final AppDb _db = locator<AppDb>();

  @override
  Future<List<Order>> getOrders(int page) => _db.getUserId()
      .then((userId) => _api.dio.get('orders?per_page=${AppConfig.paginationLimit}&page=$page&customer=$userId'))
      .then((response) => (response.data as List).map((item) => Order.fromJson(item)).toList());

}

abstract class OrdersDataSource {
  Future<List<Order>> getOrders(int page);
}