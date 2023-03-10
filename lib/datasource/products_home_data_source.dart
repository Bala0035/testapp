

import '../api/woo_api_client.dart';
import '../constants/config.dart';
import '../locator.dart';
import '../model/category.dart';
import '../model/product.dart';
import '../screens/featured/featured_filter.dart';
import '../screens/featured/featured_sort.dart';

class ProductsHomeDataSourceImpl extends ProductsHomeDataSource {
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<Product>> getProducts(int page, Sort sort, FeaturedFilter filter) => _api.dio
    .get('products?status=publish&per_page=${AppConfig.paginationLimit}&page=$page&$sort$filter')
    .then((response) => (response.data as List).map((item) => Product.fromJson(item)).toList());

  @override
  Future<List<Category>> getCategories(int page) => _api.dio
    .get('products/categories?per_page=${AppConfig.paginationLimit}&page=$page')
    .then((response) => (response.data as List).map((item) => Category.fromJson(item)).toList());


  @override
  Future<double> getMostExpensiveProduct() => _api.dio
    .get('products?status=publish&per_page=1&page=1&order=desc&orderby=price')
    .then((response) => double.tryParse((response.data as List).map((item) => Product.fromJson(item)).toList()[0].price) ?? 1000);
}

abstract class ProductsHomeDataSource {
  Future<List<Product>> getProducts(int page, Sort sort, FeaturedFilter filter);

  Future<double> getMostExpensiveProduct();

  Future<List<Category>> getCategories(int page);
}