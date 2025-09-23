import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_events.dart';
part 'login_state.dart';

class loginBloc extends Bloc<loginEvent, loginState> {
  loginBloc() : super(loginInitial()) {
    on<loginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
