import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_cubit.dart';
import 'product_view.dart';

class ProductScreen extends StatelessWidget {
  final int id;

  ProductScreen(this.id);

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProductCubit(),
    child: ProductView(id),
  );

}