import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

/// Generates a new BLoC boilerplate with a view, state, bloc, and events file.
void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand('generate', ArgParser()
    ..addOption('name',
        abbr: 'n', help: 'The name of the BLoC to generate.', mandatory: true));
  parser.addCommand('add-handler', ArgParser()
    ..addOption('name',
        abbr: 'n',
        help: 'The name of the BLoC to modify (e.g., "Login").',
        mandatory: true)
    ..addOption('handler',
        abbr: 'h',
        help: 'The name of the handler to add (e.g., "FetchData").',
        mandatory: true));

  try {
    final ArgResults results = parser.parse(arguments);
    final String? command = results.command?.name;

    if (command == 'generate') {
      final String blocName = results.command!['name'] as String;
      final String snakeCaseBlocName = _toSnakeCase(blocName);

      print('Generating BLoC boilerplate for "$blocName"...');

      final blocDir = Directory(p.join(Directory.current.path, snakeCaseBlocName));
      if (!blocDir.existsSync()) blocDir.createSync(recursive: true);

      _generateFile(p.join(blocDir.path, 'view.dart'), _createViewTemplate(blocName));
      _generateFile(p.join(blocDir.path, 'state.dart'), _createStateTemplate(blocName));
      _generateFile(p.join(blocDir.path, 'events.dart'), _createEventsTemplate(blocName));
      _generateFile(p.join(blocDir.path, 'bloc.dart'), _createBlocTemplate(blocName));

      print('Successfully generated BLoC for "$blocName" in ${blocDir.path}');
    } else if (command == 'add-handler') {
      final String blocName = results.command!['name'] as String;
      final String handlerName = results.command!['handler'] as String;
      final String snakeCaseBlocName = _toSnakeCase(blocName);

      print('Adding handler for "$handlerName" to "$blocName"...');

      final blocDir = Directory(p.join(Directory.current.path, snakeCaseBlocName));
      if (!blocDir.existsSync()) {
        print('Error: Directory for BLoC "$blocName" not found. Please run the "generate" command first.');
        return;
      }

      final eventsFile = File(p.join(blocDir.path, 'events.dart'));
      final stateFile = File(p.join(blocDir.path, 'state.dart'));
      final blocFile = File(p.join(blocDir.path, 'bloc.dart'));

      if (!eventsFile.existsSync() || !stateFile.existsSync() || !blocFile.existsSync()) {
        print('Error: BLoC files not found in ${blocDir.path}.');
        return;
      }

      // Add new event
      final eventContent = eventsFile.readAsStringSync();
      final newEventContent = eventContent.replaceFirst('}', _createEventsTemplate(blocName, handlerName));
      eventsFile.writeAsStringSync(newEventContent);
      print('  ✓ Added event to events.dart');

      // Add new state
      final stateContent = stateFile.readAsStringSync();
      final newStatusName = _toCamelCase(handlerName);
      final newStateContent = stateContent.replaceFirst('}', _createStateTemplate(blocName, newStatusName));
      stateFile.writeAsStringSync(newStateContent);
      print('  ✓ Added state status to state.dart');

      // Add new handler
      final blocContent = blocFile.readAsStringSync();
      final newBlocContent = blocContent.replaceFirst('}', _createBlocTemplate(blocName, handlerName));
      blocFile.writeAsStringSync(newBlocContent);
      print('  ✓ Added handler to bloc.dart');
      
      print('Successfully added handler "$handlerName" to BLoC "$blocName"');
    } else {
      print('Error: Invalid command. Use "generate" or "add-handler".');
      print(parser.usage);
    }
  } on ArgParserException catch (e) {
    print(e.message);
    print(parser.usage);
  } catch (e) {
    print('Error: $e');
  }
}

/// A helper function to generate a file with the given content.
void _generateFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.createSync(recursive: true);
  }
  file.writeAsStringSync(content);
  print('  ✓ Created: $path');
}

/// Converts a camelCase string to snake_case.
String _toSnakeCase(String text) {
  final exp = RegExp(r'(?<=[a-z])[A-Z]');
  return text.replaceAllMapped(exp, (m) => '_${m.group(0)}').toLowerCase();
}

String _toCamelCase(String text) {
  if (text.isEmpty) return text;
  final parts = text.split('_');
  if (parts.length <= 1) return text.toLowerCase();
  return parts.first.toLowerCase() + parts.sublist(1).map((part) => part[0].toUpperCase() + part.substring(1)).join('');
}

/// Creates the template string for the BLoC view.
String _createViewTemplate(String blocName) {
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

/// Creates the template string for the BLoC state.
String _createStateTemplate(String blocName, [String? newStatusName]) {

    if (newStatusName != null) {
    return """}""";
  }

  return """
import 'package:equatable/equatable.dart';

enum ${blocName}Status { initial, loading, loaded, error }

class ${blocName}State extends Equatable {
  final ${blocName}Status status;
  final String? error;

  const ${blocName}State({
    required this.status,
    this.error,
  });

  factory ${blocName}State.initial() => const ${blocName}State(
    status: ${blocName}Status.initial,
  );

  ${blocName}State copyWith({
    ${blocName}Status? status,
    String? error,
  }) {
    return ${blocName}State(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
""";
}

/// Creates the template string for the BLoC events.
String _createEventsTemplate(String blocName, [String? newEventName]) {
  if (newEventName != null) {
    return """}

class ${newEventName}Event extends ${blocName}Event {}
""";
  }
  return """
abstract class ${blocName}Event {}

class ${blocName}InitEvent extends ${blocName}Event {}
""";
}

/// Creates the template string for the BLoC bloc.
String _createBlocTemplate(String blocName, [String? handlerName]) {
  if (handlerName != null) {
    final eventName = '${handlerName}Event';
    final handlerMethodName = '_on${handlerName}';
    return """
  on<${eventName}>(${handlerMethodName});
}

  Future<void> ${handlerMethodName}(${eventName} event, Emitter<${blocName}State> emit) async {
    try {
   
    } catch (e) {
      emit(state.copyWith(status: ${blocName}Status.error, error: e.toString()));
    }
  }


""";
  }
  return """
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'state.dart';

class ${blocName}Bloc extends Bloc<${blocName}Event, ${blocName}State> {
  ${blocName}Bloc() : super(${blocName}State.initial()) {
    on<${blocName}InitEvent>(_onInit);
  }

  Future<void> _onInit(${blocName}InitEvent event, Emitter<${blocName}State> emit) async {
    try {
      emit(state.copyWith(status: ${blocName}Status.loading));
      // Iniatial task here
      emit(state.copyWith(
        status: ${blocName}Status.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ${blocName}Status.error, error: e.toString()));
    }
  }
}
""";
}
