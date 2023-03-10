import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_order_cubit.dart';
import 'create_order_view.dart';

class CreateOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CreateOrderCubit(),
    child: CreateOrderView(),
  );
}