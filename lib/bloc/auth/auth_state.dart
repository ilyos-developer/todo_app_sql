part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class GoHomeScreenState extends AuthState {}

class SecureSettingState extends AuthState {}
