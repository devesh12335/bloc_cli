/// Creates the template string for the BLoC view.
String createViewTemplate(String blocName) {
  return """
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'state.dart';

class ${blocName}Page extends StatelessWidget {
  const ${blocName}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ${blocName}Bloc()..add(${blocName}InitEvent()),
      child: BlocConsumer<${blocName}Bloc, ${blocName}State>(
        listener: (context, state) {
          // handle navigation or snackbars
        },
        builder: (context, state) {
          switch (state.status) {
            case ${blocName}Status.initial:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case ${blocName}Status.loaded:
              return ${blocName}LoadedPage();
            case ${blocName}Status.error:
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

class ${blocName}LoadedPage extends StatelessWidget {
  const ${blocName}LoadedPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: Center(child: Text('${blocName}',style: TextStyle(fontSize: 30),),),);
  }
}
""";
}