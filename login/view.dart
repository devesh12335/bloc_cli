import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc()..add(LoginInitEvent()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          // handle navigation or snackbars
        },
        builder: (context, state) {
          switch (state.status) {
            case LoginStatus.initial:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case LoginStatus.loaded:
              return LoginLoadedPage();
            case LoginStatus.error:
              return Scaffold(
                body: Center(
                  child: Text(state.error ?? "An error occurred"),
                ),
              );
            default:
              return const Scaffold(
                body: Center(child: Text("Unknown state")),
              );
          }
        },
      ),
    );
  }
}

class LoginLoadedPage extends StatelessWidget {
  const LoginLoadedPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: Center(child: Text('Login',style: TextStyle(fontSize: 30),),),);
  }
}
