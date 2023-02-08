import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/database.dart';
import '../../datasource/product_data_source.dart';
import '../../locator.dart';
import 'product_state.dart';


class ProductCubit extends Cubit<ProductState> {
  final ProductDataSource _ds = locator<ProductDataSource>();
  final AppDb _db = locator<AppDb>();
  
  ProductCubit() : super(InitialProductState());

  void getProduct(int id) {
    emit(LoadingProductState());
    _ds.getProducts(id).then((product) {
      _db.saveProductView(product);
      emit(ContentProductState(product));
    }).catchError((error) {
      emit(ErrorProductState());
    });
  }
}