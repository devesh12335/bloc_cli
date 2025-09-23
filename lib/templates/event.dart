
/// Creates the template string for the BLoC events.
String createEventsTemplate(String blocName, [String? newEventName]) {
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
