import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

/// Generates a new BLoC boilerplate with a view, state, bloc, and events file.
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('name',
        abbr: 'n', help: 'The name of the BLoC to generate.', mandatory: true);

  try {
    final results = parser.parse(arguments);
    final blocName = results['name'] as String;
    final snakeCaseBlocName = _toSnakeCase(blocName);

    print('Generating BLoC boilerplate for "$blocName"...');

    // Define directory structure
    final blocDir = Directory(p.join(Directory.current.path, snakeCaseBlocName));
    final viewDir = Directory(blocDir.path);
    final stateDir = Directory(blocDir.path);
    final eventsDir = Directory(blocDir.path);
    final blocFileDir = Directory(blocDir.path);

    // Create directories
    if (!blocDir.existsSync()) blocDir.createSync();
    if (!viewDir.existsSync()) viewDir.createSync();
    if (!stateDir.existsSync()) stateDir.createSync();
    if (!eventsDir.existsSync()) eventsDir.createSync();
    if (!blocFileDir.existsSync()) blocFileDir.createSync();

    // Generate files with template content
    _generateFile(
        p.join(viewDir.path, 'view.dart'), _createViewTemplate(blocName));
    _generateFile(
        p.join(stateDir.path, 'state.dart'), _createStateTemplate(blocName));
    _generateFile(
        p.join(eventsDir.path, 'events.dart'), _createEventsTemplate(blocName));
    _generateFile(
        p.join(blocFileDir.path, 'bloc.dart'), _createBlocTemplate(blocName));

    print('Successfully generated BLoC for "$blocName" in ${blocDir.path}');
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

/// Creates the template string for the BLoC view.
String _createViewTemplate(String blocName) {
  final snakeCaseBlocName = _toSnakeCase(blocName);
  return """
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/${snakeCaseBlocName}_bloc.dart';

class ${blocName}View extends StatelessWidget {
  const ${blocName}View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ${blocName}Bloc(),
      child: const Scaffold(
        body: Center(
          child: Text('${blocName} View'),
        ),
      ),
    );
  }
}
""";
}

/// Creates the template string for the BLoC state.
String _createStateTemplate(String blocName) {
  return """
part of '../bloc/${_toSnakeCase(blocName)}_bloc.dart';

sealed class ${blocName}State {}

final class ${blocName}Initial extends ${blocName}State {}
""";
}

/// Creates the template string for the BLoC events.
String _createEventsTemplate(String blocName) {
  return """
part of '../bloc/${_toSnakeCase(blocName)}_bloc.dart';

sealed class ${blocName}Event {}
""";
}

/// Creates the template string for the BLoC bloc.
String _createBlocTemplate(String blocName) {
  return """
import 'package:flutter_bloc/flutter_bloc.dart';

part '${_toSnakeCase(blocName)}_events.dart';
part '${_toSnakeCase(blocName)}_state.dart';

class ${blocName}Bloc extends Bloc<${blocName}Event, ${blocName}State> {
  ${blocName}Bloc() : super(${blocName}Initial()) {
    on<${blocName}Event>((event, emit) {
      // TODO: implement event handler
    });
  }
}
""";
}
