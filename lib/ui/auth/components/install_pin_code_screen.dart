import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/bloc/auth/auth_bloc.dart';

class InstallPinCode extends StatelessWidget {
  InstallPinCode({Key? key}) : super(key: key);

  final pinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Установите пин-код"),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextFormField(
              controller: pinCode,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (value) {
                if (value.length == 4) {
                  BlocProvider.of<AuthBloc>(context).add(
                    InstallCodeEvent(int.parse(value)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Пин-код установлен"),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
