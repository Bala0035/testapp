import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/database.dart';
import '../../datasource/cart_data_source.dart';
import '../../locator.dart';
import 'cart_state.dart';
class CartCubit extends Cubit<CartState> {

  final CartDataSource _ds = locator<CartDataSource>();
  final AppDb _db = locator<AppDb>();

  CartCubit() : super(InitialCartState());

  void getCart() async {
    emit(LoadingCartState());
    var isAuthenticated = await _db.isAuthenticated();
    if (!isAuthenticated) {
      emit(NoAuthCartState());
    } else {
      _ds.getCart().then((cart) {
        if (cart.items.isEmpty || cart.isEmpty) {
          emit(EmptyCartState());
        } else {
          emit(ContentCartState(cart));
        }
      }).catchError((error) {
        print('$error');
        emit(ErrorCartState());
      });
    }
  }

  void deleteItem(String itemKey, int originalId) {
    emit(LoadingCartState());
    _ds.deleteItem(itemKey, originalId).then((cart) {
      if (cart.items.isEmpty || cart.isEmpty) {
        emit(EmptyCartState());
      } else {
        emit(ContentCartState(cart));
      }
    }).catchError((error) {
      print('$error');
      emit(ErrorCartState());
    });
  }
}