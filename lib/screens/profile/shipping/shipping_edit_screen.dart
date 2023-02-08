import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_cubit.dart';
import 'shipping_edit_view.dart';

class ShippingEditScreen extends StatelessWidget {

  ShippingEditScreen();

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileCubit(),
    child: ShippingEditView(),
  );

}