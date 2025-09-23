import 'dart:io';

import 'package:args/args.dart';
import 'package:dev_bloc_cli/templates/bloc.dart';
import 'package:dev_bloc_cli/templates/event.dart';
import 'package:dev_bloc_cli/templates/state.dart';
import 'package:dev_bloc_cli/templates/view.dart';
import 'package:path/path.dart' as p;

/// Generates a new BLoC boilerplate with a view, state, bloc, and events file.
void main(List<String> arguments) {
  final parser = ArgParser();
  parser.addCommand(
    'generate',
    ArgParser()..addOption(
      'name',
      abbr: 'n',
      help: 'The name of the BLoC to generate.',
      mandatory: true,
    ),
  );

  parser.addCommand(
    'add-handler',
    ArgParser()
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the BLoC to modify (e.g., "Login").',
        mandatory: true,
      )
      ..addOption(
        'handler',
        abbr: 'h',
        help: 'The name of the handler to add (e.g., "FetchData").',
        mandatory: true,
      ),
  );

  parser.addCommand(
    'add-state',
    ArgParser()
      ..addOption(
        'name',
        abbr: 'n',
        help: 'The name of the BLoC to modify (e.g., "Login").',
        mandatory: true,
      )
      ..addOption(
        'property',
        abbr: 'p',
        help: 'The state property to add (e.g., "user:User").',
        mandatory: true,
      ),
  );
  try {
    final ArgResults results = parser.parse(arguments);
    final String? command = results.command?.name;

    if (command == 'generate') {
      final String blocName = results.command!['name'] as String;
      final String snakeCaseBlocName = _toSnakeCase(blocName);

      print('Generating BLoC boilerplate for "$blocName"...');

      final blocDir = Directory(
        p.join(Directory.current.path, snakeCaseBlocName),
      );
      if (!blocDir.existsSync()) blocDir.createSync(recursive: true);

      _generateFile(
        p.join(blocDir.path, 'view.dart'),
        createViewTemplate(blocName),
      );
      _generateFile(
        p.join(blocDir.path, 'state.dart'),
        createStateTemplate(blocName),
      );
      _generateFile(
        p.join(blocDir.path, 'events.dart'),
        createEventsTemplate(blocName),
      );
      _generateFile(
        p.join(blocDir.path, 'bloc.dart'),
        createBlocTemplate(blocName),
      );

      print('Successfully generated BLoC for "$blocName" in ${blocDir.path}');
    } else if (command == 'add-handler') {
      final String blocName = results.command!['name'] as String;
      final String handlerName = results.command!['handler'] as String;
      final String snakeCaseBlocName = _toSnakeCase(blocName);

      print('Adding handler for "$handlerName" to "$blocName"...');

      final blocDir = Directory(
        p.join(Directory.current.path, snakeCaseBlocName),
      );
      if (!blocDir.existsSync()) {
        print(
          'Error: Directory for BLoC "$blocName" not found. Please run the "generate" command first.',
        );
        return;
      }

      final eventsFile = File(p.join(blocDir.path, 'events.dart'));
      final stateFile = File(p.join(blocDir.path, 'state.dart'));
      final blocFile = File(p.join(blocDir.path, 'bloc.dart'));

      if (!eventsFile.existsSync() ||
          !stateFile.existsSync() ||
          !blocFile.existsSync()) {
        print('Error: BLoC files not found in ${blocDir.path}.');
        return;
      }

      // Add new event
      final eventContent = eventsFile.readAsStringSync();
      final newEventContent = eventContent.replaceFirst(
        '}',
        createEventsTemplate(blocName, handlerName),
      );
      eventsFile.writeAsStringSync(newEventContent);
      print('  ✓ Added event to events.dart');

      // Add new state
      final stateContent = stateFile.readAsStringSync();
      final newStatusName = _toCamelCase(handlerName);
      final newStateContent = stateContent.replaceFirst(
        '}',
        createStateTemplate(blocName, newStatusName),
      );
      stateFile.writeAsStringSync(newStateContent);
      print('  ✓ Added state status to state.dart');

      // Add new handler
      final blocContent = blocFile.readAsStringSync();
      final newBlocContent = blocContent.replaceFirst(
        '}',
        createBlocTemplate(blocName, handlerName),
      );
      blocFile.writeAsStringSync(newBlocContent);
      print('  ✓ Added handler to bloc.dart');

      print('Successfully added handler "$handlerName" to BLoC "$blocName"');
    } else if (command == 'add-state') {
      final String blocName = results.command!['name'] as String;
      final String propertyString = results.command!['property'] as String;
      final String snakeCaseBlocName = _toSnakeCase(blocName);

      print('Adding state property "$propertyString" to "$blocName"...');

      final parts = propertyString.split(':');
      if (parts.length != 2) {
        print('Error: Invalid property format. Use "name:DataType".');
        return;
      }
      final propertyName = parts[0];
      final propertyType = parts[1];

      final blocDir = Directory(
        p.join(Directory.current.path, snakeCaseBlocName),
      );
      if (!blocDir.existsSync()) {
        print(
          'Error: Directory for BLoC "$blocName" not found. Please run the "generate" command first.',
        );
        return;
      }

      final stateFile = File(p.join(blocDir.path, 'state.dart'));
      if (!stateFile.existsSync()) {
        print('Error: State file not found in ${blocDir.path}.');
        return;
      }

      var stateContent = stateFile.readAsStringSync();

      // Add new property to class definition
      stateContent = stateContent.replaceFirst(
        '  final String? error;',
        '  final String? error;\n  final $propertyType? $propertyName;',
      );

      // Add property to constructor
      stateContent = stateContent.replaceFirst(
        'this.error,',
        'this.error,\n    this.$propertyName,',
      );

      // Add property to copyWith method signature
      stateContent = stateContent.replaceFirst(
        'String? error,',
        'String? error,\n    $propertyType? $propertyName,',
      );

      // Add property to copyWith method return
      stateContent = stateContent.replaceFirst(
        'error: error ?? this.error,',
        'error: error ?? this.error,\n      $propertyName: $propertyName ?? this.$propertyName,',
      );

      // Add property to props list
      stateContent = stateContent.replaceFirst('];', ', $propertyName];');

      stateFile.writeAsStringSync(stateContent);
      print('  ✓ Added state property to state.dart');

      print(
        'Successfully added state property "$propertyName" to BLoC "$blocName"',
      );
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
  return parts.first.toLowerCase() +
      parts
          .sublist(1)
          .map((part) => part[0].toUpperCase() + part.substring(1))
          .join('');
}
