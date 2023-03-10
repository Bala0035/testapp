

import '../api/woo_api_client.dart';
import '../locator.dart';
import '../model/payment_method.dart';
class PaymentMethodDataSourceImpl extends PaymentMethodDataSource {
  final WooApiClient _api = locator<WooApiClient>();
  
  @override
  Future<List<PaymentMethod>> getPaymentMethods() => _api.dio
      .get('payment_gateways')
      .then((response) => (response.data as List).map((item) => PaymentMethod.fromJson(item)).toList());
}

abstract class PaymentMethodDataSource {
  Future<List<PaymentMethod>> getPaymentMethods();
}