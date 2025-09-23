/// Creates the template string for the BLoC state.
String createStateTemplate(String blocName, [String? newStatusName]) {

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