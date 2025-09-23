import 'package:equatable/equatable.dart';

enum LoginStatus { initial, loading, loaded, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? error;
  final List<Product>? ffooo;
  final bool? fooo;
  final String? displayName;

  const LoginState({
    required this.status,
    this.error,
    this.ffooo,
    this.fooo,
    this.displayName,
  });

  factory LoginState.initial() => const LoginState(
    status: LoginStatus.initial,
  );

  LoginState copyWith({
    LoginStatus? status,
    String? error,
    List<Product>? ffooo,
    bool? fooo,
    String? displayName,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error ?? this.error,
      ffooo: ffooo ?? this.ffooo,
      fooo: fooo ?? this.fooo,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  List<Object?> get props => [status, error, displayName, fooo, ffooo];
}
