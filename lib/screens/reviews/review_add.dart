import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../datasource/product_review_data_source.dart';
import '../../extensions/extensions_context.dart';
import '../../locator.dart';
import '../../widget/widget_diaolg.dart';

class AddReviewScreen extends StatefulWidget {
  final int productId;

  AddReviewScreen(this.productId);

  @override
  State<StatefulWidget> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final ProductReviewDataSource _ds = locator<ProductReviewDataSource>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _reviewController = TextEditingController();

  double _rating = 5;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('review_add').tr(),
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _reviewController,
                      // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                        // color: Colors.white
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 8,
                    decoration: _decorate(tr('review')),
                    maxLength: 600,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Review is required';
                      }
                      return null;
                    }
                  ),
                  RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      itemCount: 5,
                      allowHalfRating: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print('newRating = $rating');
                        setState(() {
                          _rating = rating;
                        });
                      }
                  ),
                  _bottomBar()
                ],
              ),
            ),
          ),
        ),
      ),
    )
  );

  Widget _bottomBar() => Container(
    padding: EdgeInsets.only(bottom: 8, top: 32, right: 32, left: 32),
    height: 92,
    child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          hideKeyboardForce(context);
          _postReview();
        }
      },
      child: Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FaIcon(FontAwesomeIcons.commentMedical),
              // SizedBox(width: 8),
              Text(
                'review_add_action',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ).tr(),
            ],
          )
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF62A1E2)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Colors.blue)
          ),
        ),
      ),
    ),
  );

  void _postReview() {
    _ds.addReview(widget.productId, _rating, _reviewController.text)
        .then((value) {
          Navigator.of(context)..pop()..pop();
          showDialog(
            context: context,
            builder: (ctx) => CustomDialogBox(
              title: 'Thank you!',
              descriptions: 'Your review posted successfully.',
            ),
          );
        }).catchError((error) {
          showDialog(
            context: context,
              builder: (ctx) => CustomDialogBox(
                title: 'Oops...',
                descriptions: 'There was some issue while posting your review. Please, try again.',
              ),
          );
        });
  }

  InputDecoration _decorate(String label, {String prefix = ''}) => InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.0)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1.0)
      ),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
      ),
      focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
      ),
      // labelStyle: TextStyle(color: Colors.white),
      labelText: label,
      prefixText: prefix
  );
}