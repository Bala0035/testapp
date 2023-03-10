import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../constants/config.dart';
import '../../datasource/category_attribute_data_source.dart';
import '../../locator.dart';
import '../../model/product.dart';
import '../../widget/shimmer.dart';
import '../../widget/widget_product_grid.dart';
import '../../widget/widget_retry.dart';
import 'fliter/category_filter_screen.dart';
import 'info/category_info_screen.dart';

class CategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categorySlug;
  final String categoryTitle;
  final String categoryDescription;
  final String categoryImage;

  CategoryScreen(this.categoryId, this.categorySlug, {this.categoryTitle = '', this.categoryDescription = '', this.categoryImage = ''});

  @override
  State<StatefulWidget> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final CategoryAttributeDateSource _ds = locator<CategoryAttributeDateSource>();

  final PagingController<int, CategoryProduct> _pagingController = PagingController(firstPageKey: 1);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) => _fetchProducts(pageKey));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.categoryTitle),
      automaticallyImplyLeading: false,
      leading: BackButton(),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryInfoScreen(
              widget.categoryTitle,
              widget.categoryDescription,
              widget.categoryImage
          ))),
          icon: Icon(
            Icons.info,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openEndDrawer();
          },
          icon: Icon(
            Icons.filter_alt_rounded,
            color: Colors.white,
          ),
        ),
      ],
    ),
    endDrawer: Drawer(
      child: CategoryFilterScreen(() {
        _pagingController.refresh();
      }),
    ),
    body: RefreshIndicator(
      onRefresh: () => Future.sync(() {
        _pagingController.refresh();
      }),
      child: PagedGridView(
        pagingController: _pagingController,
        showNewPageErrorIndicatorAsGridChild: false,
        showNewPageProgressIndicatorAsGridChild: false,
        showNoMoreItemsIndicatorAsGridChild: false,
        builderDelegate: PagedChildBuilderDelegate<CategoryProduct>(
          itemBuilder: (ctx, item, index) => CategoryProductGridItem(item),
          firstPageProgressIndicatorBuilder: (_) => FeaturedShimmer(true),
          firstPageErrorIndicatorBuilder: (_) => ErrorRetryWidget(() {
            _pagingController.refresh();
          }),
          newPageProgressIndicatorBuilder: (_) => FeaturedShimmer(false),
          newPageErrorIndicatorBuilder: (_) => CircularProgressIndicator()
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width / ((MediaQuery.of(context).size.height / 2) + 10),
        ),
      ),
    ),
  );

  Future<void> _fetchProducts(int page) async {
    try {
      final items = await _ds.getProducts(widget.categorySlug, page).catchError((error, stackTrace) {
        print(error.toString());
      });
      final isLast = items.length < AppConfig.paginationLimit;
      if (isLast) {
        _pagingController.appendLastPage(items);
      } else {
        final next = page + 1;
        _pagingController.appendPage(items, next);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }
}