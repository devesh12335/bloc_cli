import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, loaded, error   }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? error;

  const LoginState({
    required this.status,
    this.error,
  });

  factory LoginState.initial() => const LoginState(
    status: LoginStatus.initial,
  );

  LoginState copyWith({
    LoginStatus? status,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
