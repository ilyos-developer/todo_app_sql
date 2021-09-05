import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial());

  var code;
  bool isSecure = false;
  final storage = new FlutterSecureStorage();

  final LocalAuthentication localAuthentication = LocalAuthentication();
  bool isAuthenticated = false;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    biometricCheck() async {
      bool isBiometricSupported = await localAuthentication.isDeviceSupported();
      bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;

      if (isBiometricSupported && canCheckBiometrics) {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason:
              "Пожалуйста, заполните биометрические данные, чтобы зайти",
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        );
      }
      print("biometric: $isAuthenticated");
    }

    if (event is AuthorizationCheckEvent) {
      code = await storage.read(key: "code");
      print("line 24 $code");
      if (code != null) {
        yield AuthInitial();
        biometricCheck();
        if (isAuthenticated) {
          yield GoHomeScreenState();
        }
      } else {
        yield GoHomeScreenState();
      }
    }
    if (event is BiometricsCheckEvent) {
      biometricCheck();
      if (isAuthenticated) {
        yield GoHomeScreenState();
      }
    }
    if (event is InstallCodeEvent) {
      code = event.code;
      await storage.write(key: "code", value: event.code.toString());
      isSecure = true;
      yield SecureSettingState();
    }
    if (event is DisableAuthEvent) {
      isSecure = event.isSecure!;
      await storage.delete(key: "code");
    }
  }
}
