import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/bloc/auth/auth_bloc.dart';

import 'install_pin_code_screen.dart';

class SwitchSecurity extends StatefulWidget {
  const SwitchSecurity({Key? key}) : super(key: key);

  @override
  _SwitchSecurityState createState() => _SwitchSecurityState();
}

class _SwitchSecurityState extends State<SwitchSecurity> {
  final authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Код-пароль"),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstallPinCode(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Код-пароль"),
                        Switch(
                          value: authBloc.isSecure,
                          onChanged: (value) {
                            authBloc.add(
                              DisableAuthEvent(value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                (state is SecureSettingState)
                    ? Container(color: Colors.red)
                    : SizedBox()
              ],
            ),
          );
        },
      ),
    );
  }
}
