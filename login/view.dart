import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login_bloc.dart';

class loginView extends StatelessWidget {
  const loginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc(),
      child: const Scaffold(
        body: Center(
          child: Text('login View'),
        ),
      ),
    );
  }
}
