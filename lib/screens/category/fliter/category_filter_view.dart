import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../database/filter.dart';
import '../../../widget/stateful_wrapper.dart';
import 'category_filter_cubit.dart';
import 'category_filter_item.dart';
import 'category_filter_state.dart';

class CategoryFilterView extends StatelessWidget {
  final VoidCallback onChanged;

  CategoryFilterView(this.onChanged);

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<CategoryFilterCubit>().getAttributes();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: SizedBox(),
          // title: Text('Filters'),
        ),
        body: BlocListener<CategoryFilterCubit, CategoryFilterState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              //ToDo ...
            }
          },
          child: BlocBuilder<CategoryFilterCubit, CategoryFilterState>(
            builder: (context, state) {
              switch (state.runtimeType) {
                case EmptyCategoryFilterState:
                  return _buildEmpty();
                case ErrorCategoryFilterState:
                  return _buildError();
                case ContentCategoryFilterState:
                  return _buildContent(context, (state as ContentCategoryFilterState).filters);
                default:
                  return _buildLoading();
              }
            },
          ),
        ),
      )
  );

  Widget _buildContent(BuildContext context, List<Filter> attrs) => SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // for (var item in attrs) if (item.values.isNotEmpty) CategoryFilterItem(item)
        for (var item in attrs) CategoryFilterItem(item, onChanged)
      ],
    ),
  );

  Widget _buildEmpty() => Text('empty');

  Widget _buildLoading() => Column(
    children: [
      CircularProgressIndicator(),
    ],
  );

  Widget _buildError() => Text('error');
}