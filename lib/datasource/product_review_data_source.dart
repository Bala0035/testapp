

import '../api/woo_api_client.dart';
import '../constants/config.dart';
import '../database/database.dart';
import '../locator.dart';
import '../model/customer_profile.dart';
import '../model/product_rewiew.dart';

class ProductReviewDataSourceImpl extends ProductReviewDataSource {
  final AppDb _db = locator<AppDb>();
  final WooApiClient _api = locator<WooApiClient>();

  @override
  Future<List<ProductReview>> getReviews(int productId, int page) => _api.dio
      .get('products/reviews?per_page=${AppConfig.paginationLimit}&product=$productId&page=$page')
      .then((response) => (response.data as List).map((item) => ProductReview.fromJson(item)).toList());

  @override
  Future<ProductReview> addReview(int productId, double rating, String review) => _db.getUser()
      .then((user) => _api.dio.post('products/reviews', data: {
        'product_id': productId,
        'review': review,
        'reviewer': user.name,
        'reviewer_email': user.email,
        'rating': rating
      }))
      .then((response) => ProductReview.fromJson(response.data));
}

abstract class ProductReviewDataSource {
  Future<List<ProductReview>> getReviews(int productId, int page);
  
  Future<ProductReview> addReview(int productId, double rating, String review);
}