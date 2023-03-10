import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../datasource/cart_data_source.dart';
import '../../../datasource/customer_profile_data_source.dart';
import '../../../datasource/orders_create_data_source.dart';
import '../../../datasource/payment_methods_data_source.dart';
import '../../../datasource/shipping_method_data_source.dart';
import '../../../locator.dart';
import '../../../model/cart_response.dart';
import '../../../model/customer_profile.dart';
import '../../../model/order.dart';
import '../../../model/payment_method.dart';
import '../../../model/shipping_method.dart';
import 'create_order_model.dart';
import 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {

  final CartDataSource _cart = locator<CartDataSource>();
  final CustomerProfileDataSource _profile = locator<CustomerProfileDataSource>();
  final ShippingMethodDataSource _shipping = locator<ShippingMethodDataSource>();
  final PaymentMethodDataSource _payment = locator<PaymentMethodDataSource>();
  final CreateOrderDataSource _create = locator<CreateOrderDataSource>();

  bool _orderTermsAccepted = false;
  int _dataShippingIndex = -1;
  int _dataPaymentIndex = -1;
  CartResponse _dataCart = CartResponse.empty();
  CreateOrderRecipient _dataRecipient = CreateOrderRecipient.empty();
  CreateOrderShipping _dataShipping = CreateOrderShipping.empty();
  List<ShippingMethod> _dataShippingMethods = [];
  List<PaymentMethod> _dataPaymentMethods = [];

  CreateOrderCubit() : super(InitialCreateOrderState());

  void getItems() {
    Future.wait([
      _cart.getCart(),
      _profile.getProfile(),
      _shipping.getShippingMethods(),
      _payment.getPaymentMethods(),
    ]).then((List<dynamic> data) {
      if (_dataShippingIndex == -1) _dataShippingIndex = 0;
      if (_dataPaymentIndex == -1) _dataPaymentIndex = 0;
      _dataCart = data[0] as CartResponse;
      _dataRecipient = CreateOrderRecipient(
        (data[1] as CustomerProfile).firstName,
        (data[1] as CustomerProfile).lastName,
        (data[1] as CustomerProfile).billing.phone,
        (data[1] as CustomerProfile).billing.email,
      );
      _dataShipping = CreateOrderShipping(
        (data[1] as CustomerProfile).shipping.country,
        (data[1] as CustomerProfile).shipping.state,
        (data[1] as CustomerProfile).shipping.city,
        (data[1] as CustomerProfile).shipping.postcode,
        (data[1] as CustomerProfile).shipping.address1,
        (data[1] as CustomerProfile).shipping.address2,
      );
      _dataShippingMethods = data[2] as List<ShippingMethod>;
      _dataPaymentMethods = (data[3] as List<PaymentMethod>)
        ..removeWhere((method) => method.enabled == false);

      invalidate();
    }).catchError((error) {
      print('ERRRORRRRRRR $error');
      emit(ErrorCreateOrderState());
    });
  }

  void invalidate() {
    emit(
        ContentCreateOrderState(
            _dataCart,
            _dataRecipient,
            _dataShipping,
            _dataShippingMethods,
            _dataPaymentMethods,
            _dataShippingIndex,
            _dataPaymentIndex,
            _orderTermsAccepted
        )
    );
  }

  List<CreateOrderValidationError> validate() {
    List<CreateOrderValidationError> result = [];
    if (!_orderTermsAccepted) {
      result.add(CreateOrderValidationError.TERMS_NOT_ACCEPTED);
    }
    return result;
  }

  void createOrder() {
    var validation = validate();
    if (validation.isNotEmpty) {
      emit(InvalidCreateOrderState(validation));
    } else {
      emit(LoadingCreateOrderState());
      Future.wait([
        _create.createOrder(
            _dataCart.items,
            _dataRecipient,
            _dataShipping,
            _dataShippingMethods[_dataShippingIndex],
            _dataPaymentMethods[_dataPaymentIndex]
        ),
        _cart.clearCart()
      ]).then((data) {
        emit(CompleteCreateOrderState(data[0] as Order));
      }).catchError((error) {
        print('Create order error: $error');
      });
    }
  }

  void onChangeTermsAccepted() {
    _orderTermsAccepted = !_orderTermsAccepted;
    invalidate();
  }

  void onShippingSelected(int index) {
    _dataShippingIndex = index;
    invalidate();
  }

  void onPaymentSelected(int index) {
    _dataPaymentIndex = index;
    invalidate();
  }
}