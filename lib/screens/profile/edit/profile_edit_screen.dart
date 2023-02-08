import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../profile_cubit.dart';
import 'profile_edit_view.dart';

class ProfileEditScreen extends StatelessWidget {

  ProfileEditScreen();

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ProfileCubit(),
    child: ProfileEditView(),
  );

}