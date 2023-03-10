import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../constants/config.dart';
import '../datasource/cart_data_source.dart';
import '../locator.dart';
import '../model/cart_response.dart';
import 'widget_cart_quantity.dart';

class CartTotalItem extends StatefulWidget {
  final CartDataSource _ds = locator<CartDataSource>();
  final CartItem item;

  CartTotalItem(this.item);

  @override
  State<StatefulWidget> createState() => _CartTotalItemState(item.totals.total.toString());

}

class _CartTotalItemState extends State<CartTotalItem> {

  final String initialTotal;

  var isLoading = false;
  var total = '';

  _CartTotalItemState(this.initialTotal);

  @override
  void initState() {
    super.initState();
    total = initialTotal;
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Text(
      //   'Total: ',
      //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      // ),
      !isLoading
          ? Text(
            '$total${AppConfig.currency}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          )
          : Container(
              width: 100,
              height: 14,
              child: Shimmer(
                duration: Duration(seconds: 1),
                enabled: true,
                direction: ShimmerDirection.fromLTRB(),
                child: Container(color: Colors.white70)
              ),
          ),
      Spacer(),
      CartQuantityWidget(widget.item.itemKey, widget.item.quantity.value, () {
        updatePrice();
      }),
    ],
  );

  void updatePrice() {
    setState(() {
      isLoading = true;
    });
    widget._ds.getItem(widget.item.itemKey).then((item) {
      setState(() {
        isLoading = false;
        total = item.totals.total.toString();
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
        total = initialTotal;
      });
    });
  }

}