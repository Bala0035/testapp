import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_filter_cubit.dart';
import 'category_filter_view.dart';

class CategoryFilterScreen extends StatelessWidget {
  final VoidCallback onChanged;

  CategoryFilterScreen(this.onChanged);

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CategoryFilterCubit(),
    child: CategoryFilterView(onChanged),
  );
}