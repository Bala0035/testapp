import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart';

import '../../../extensions/extensions_context.dart';
import '../../../model/customer_profile.dart';
import '../../../widget/stateful_wrapper.dart';
import '../profile_cubit.dart';
import '../profile_state.dart';

class ProfileEditView extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) => StatefulWrapper(
      onInit: () {
        context.read<ProfileCubit>().getProfile();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener(
          listener: (context, state) {
            switch (state.runtimeType) {
              case CompleteProfileState:
                Navigator.pop(context, true);
                break;
              //ToDo ...
            }
          },
          child: BlocBuilder(
            builder: (context, state) {
              switch (state.runtimeType) {
                case InitialProfileState:
                  return _loadingState();
                case LoadingProfileState:
                  return _loadingState();
                case ContentProfileState:
                  var currentState = (state as ContentProfileState);
                  _emailController.text = currentState.profile.email;
                  _firstNameController.text = currentState.profile.firstName;
                  _lastNameController.text = currentState.profile.lastName;
                  _phoneController.text = currentState.profile.billing.phone;
                  return _contentState(context, currentState.profile);
                case ErrorProfileState:
                  return _errorState();
                case NoAuthProfileState:
                  return _errorState();
                default:
                  return _loadingState();
              }
            },
          ),
        ),
      )
  );

  Widget _contentState(BuildContext context, CustomerProfile profile) => Scaffold(
    appBar: AppBar(
      title: Text('edit_profile').tr(),
    ),
    bottomNavigationBar: Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, bottom: 16),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              hideKeyboardForce(context);
              context.read<ProfileCubit>().updateProfile(
                _emailController.text,
                _firstNameController.text,
                _lastNameController.text,
                _phoneController.text
              );
            }
          },
          child: Container(
            width: 290,
            alignment: Alignment.center,
            child: Text(
              'update_profile',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ).tr(),
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
      ),
    ),
    body: SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _emailController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                        fontSize: 16,
                        // color: Colors.white
                    ),
                    decoration: _decorate(tr('email')),
                    validator: (value) => !isEmail(value.toString()) ? 'Invalid E-Mail' : null
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _firstNameController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('first_name')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'First name is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _lastNameController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    decoration: _decorate(tr('last_name')),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Last name is required';
                      }
                      return null;
                    }
                ),
                SizedBox(height: 16),
                TextFormField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: _phoneController,
                    // cursorColor: Colors.blue,
                    style: TextStyle(
                      fontSize: 16,
                      // color: Colors.white
                    ),
                    maxLength: 12,
                    decoration: _decorate(tr('phone'), prefix: '+'),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _loadingState() => Center(
    child: CircularProgressIndicator(
      // backgroundColor: Colors.white,
      strokeWidth: 1,
    ),
  );

  Widget _errorState() => Center(
    child: Text("Error"),
  );

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