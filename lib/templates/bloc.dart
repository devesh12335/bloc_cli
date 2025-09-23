
/// Creates the template string for the BLoC bloc.
String createBlocTemplate(String blocName, [String? handlerName]) {
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