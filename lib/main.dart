import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/ui/auth/pin_code_screen.dart';
import 'package:todo_task/ui/home/home_screen.dart';

import 'bloc/home/home_bloc.dart';
import 'bloc/auth/auth_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthorizationCheckEvent()),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()..add(HomeInitialEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Task todo',
        theme: ThemeData.dark(),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial) {
              return PinCode();
            }
            if (state is GoHomeScreenState) {
              return HomeScreen();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
