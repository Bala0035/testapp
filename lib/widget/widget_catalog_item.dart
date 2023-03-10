import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../extensions/extensions_image.dart';
import '../model/category.dart';
import '../screens/category/category_screen.dart';
import 'widget_catalog_products.dart';


class CatalogItemWidget extends StatefulWidget {
  static const double imageHeight = 100;

  final Category category;

  CatalogItemWidget(this.category);

  @override
  State<StatefulWidget> createState() => _CatalogItemWidgetState();
}

class _CatalogItemWidgetState extends State<CatalogItemWidget> {

  Color _backgroundColor = Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();
    getColor(widget.category.image).then((color) {
      setState(() {
        _backgroundColor = color;
      });
    });
  }

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              child: _buildItemImage(widget.category.image),
            ),
            Opacity(
              opacity: 1.0,
              child: Container(
                  height: CatalogItemWidget.imageHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        // Color(0x80FFFFFF),
                        _backgroundColor.withAlpha(180),
                        Color(0xFFFFFFFF),
                      ],
                    ),
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    child: InvertColors(
                      child: Text(
                        '${widget.category.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: _backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  margin: EdgeInsets.only(top: 22),
                  child: CatalogProductsWidget(widget.category.id),
                ),
                Row(
                  children: [
                    SizedBox(width: 8),
                    Text(
                      '${tr('catalog_total')}: ${widget.category.count}',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(
                            0x0))
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CategoryScreen(
                            widget.category.id,
                            widget.category.slug,
                            categoryTitle: widget.category.name,
                            categoryDescription: widget.category.description,
                            categoryImage: widget.category.image,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text('catalog_view_all').tr(),
                          SizedBox(width: 8),
                          FaIcon(FontAwesomeIcons.chevronRight, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildItemImage(String image) => Container(
    // width: 120,
    height: CatalogItemWidget.imageHeight,
    child: CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer(
        duration: Duration(seconds: 1),
        enabled: true,
        direction: ShimmerDirection.fromLTRB(),
        child: Container(color: Colors.white10),
      ),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
    ),
  );
}