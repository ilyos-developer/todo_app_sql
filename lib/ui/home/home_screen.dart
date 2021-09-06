import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/bloc/home/home_bloc.dart';
import 'package:todo_task/ui/auth/components/switch_security_screen.dart';

import 'components/task_status_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc _bloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Задачи"),
            actions: [
              PopupMenuButton(
                icon: Icon(Icons.filter_list),
                onSelected: (result) {
                  _bloc.add(OrderByDeadlineEvent(result.toString()));
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: "ASC",
                    child: Text("В порядке возрастания"),
                  ),
                  const PopupMenuItem(
                    value: "DESC",
                    child: Text('В порядке убывания'),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                icon: Icon(Icons.settings),
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Text(
                  "Новые",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "В процессе",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Выполнено",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Все",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TaskStatusScreen(
                status: 0,
              ),
              TaskStatusScreen(status: 1),
              TaskStatusScreen(status: 2),
              TaskStatusScreen(),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25),
              Text(
                "Настройки",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.security),
                title: Text("Код-пароль"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SwitchSecurity(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
