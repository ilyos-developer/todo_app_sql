import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/bloc/home/home_bloc.dart';
import 'task_card.dart';

class TaskStatusScreen extends StatefulWidget {
  final int? status;

  TaskStatusScreen({Key? key, this.status}) : super(key: key);

  @override
  _TaskStatusScreenState createState() => _TaskStatusScreenState();
}

class _TaskStatusScreenState extends State<TaskStatusScreen> {
  final _taskNameController = TextEditingController();
  final _deadlineController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(GetTasksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskCard(status: widget.status),
      floatingActionButton: widget.status == 0
          ? FloatingActionButton(
              tooltip: "add new task",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Новая задача"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _taskNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Названия',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Вводите названия';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _deadlineController,
                                  decoration: InputDecoration(
                                    labelText: 'Время на выаолнения',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Вводите время';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Отменить"),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<HomeBloc>(context).add(
                                AddTaskEvent(
                                  name: _taskNameController.text,
                                  deadline: int.parse(_deadlineController.text),
                                ),
                              );
                              _taskNameController.clear();
                              _deadlineController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Добавить"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
