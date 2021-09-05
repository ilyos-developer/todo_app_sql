part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class InstallCodeEvent extends AuthEvent {
  final int code;

  InstallCodeEvent(this.code);
}

class AuthorizationCheckEvent extends AuthEvent {}

class DisableAuthEvent extends AuthEvent {
  bool? isSecure;

  DisableAuthEvent(this.isSecure);
}

class BiometricsCheckEvent extends AuthEvent {}
