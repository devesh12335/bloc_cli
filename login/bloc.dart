import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginInitEvent>(_onInit);
    on<SendDataEvent>(_onSendData);
  on<RawDataEvent>(_onRawData);
}

  Future<void> _onRawData(RawDataEvent event, Emitter<LoginState> emit) async {
    try {
   
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e.toString()));
    }
  }




  Future<void> _onSendData(SendDataEvent event, Emitter<LoginState> emit) async {
    try {
   
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e.toString()));
    }
  }




  Future<void> _onInit(LoginInitEvent event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      // Iniatial task here
      emit(state.copyWith(
        status: LoginStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.error, error: e.toString()));
    }
  }
}
