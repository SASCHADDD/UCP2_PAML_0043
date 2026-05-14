import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginProcess extends AuthEvent {
  final String email;
  final String password;

  LoginProcess({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutProcess extends AuthEvent {}

class RegisterProcess extends AuthEvent {
  final String nama;
  final String email;
  final String password;

  RegisterProcess({
    required this.nama,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [nama, email, password];
}