import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../datasource/customer_auth_data_source.dart';
import '../../extensions/extensions_context.dart';
import '../../locator.dart';
import '../../model/auth_register_response.dart';
import '../../widget/widget_diaolg.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final CustomerAuthDataSource _ds = locator<CustomerAuthDataSource>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _lController = TextEditingController();
  final TextEditingController _eController = TextEditingController();
  final TextEditingController _p1Controller = TextEditingController();
  final TextEditingController _p2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      elevation: 0,
    ),
    backgroundColor: Colors.blue,
    body: GestureDetector(
      onTap: () {
        hideKeyboard(context);
      },
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'sign_up',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w600, color: Colors.white),
                    ).tr(),
                    SizedBox(height: 32),
                    TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _lController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 0.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: tr('username'),
                        ),
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        controller: _eController,
                        cursorColor: Colors.white,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                        ),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 0.0)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: tr('email'),

                        ),
                        validator: (value) => !isEmail(value.toString()) ? 'Invalid E-Mail' : null
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _p1Controller,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 0.0)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: tr('password')
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _p2Controller,
                      cursorColor: Colors.white,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 0.0)
                          ),
                          focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 1.0)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent, width: 1.0)
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: tr('password_repeat')
                      ),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Repeat password is required';
                        } else if (value.toString() != _p1Controller.text.toString()) {
                          return 'Passwords must be the same';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            hideKeyboardForce(context);
                            _register();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Text(
                            tr('register').toUpperCase(),
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                letterSpacing: 2.0
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36.0),
                                side: BorderSide(color: Colors.white)
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'have_account',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                          ),
                        ).tr(),
                        SizedBox(width: 6),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Text(
                            'sign_in_footer',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _register() async {
    _ds.register(
      _lController.text.toString().trim(),
      _eController.text.toString().trim(),
      _p1Controller.text.toString()
    ).then((register) {
      Navigator.of(context).pop();
      showResult(tr('congratulations'), tr('sign_up_success'));
    }).catchError((error) {
      if (error is DioError) {
        var reg = WpRegResponse.fromJson(error.response!.data);
        showResult(tr('error'), reg.message);
      }
    });
  }

  void showResult(String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialogBox(
        title: title,
        descriptions: desc,
      ),
    );
  }
}