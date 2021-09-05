import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_task/bloc/home/home_bloc.dart';
import 'package:todo_task/models/task.dart';

class TaskCard extends StatelessWidget {
  final int? status;

  TaskCard({this.status});

  final _taskNameController = TextEditingController();
  final _deadlineController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final homeBloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    HomeBloc _bloc = BlocProvider.of<HomeBloc>(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is LoadedTasksState) {
          return ListView.builder(
              itemCount: state.taskList.length,
              itemBuilder: (context, index) {
                return status == state.taskList[index].status
                    ? Padding(
                        padding: EdgeInsets.only(top: 0.6, left: 4, right: 4),
                        child: Card(
                          elevation: 1.8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(state.taskList[index].task),
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(state.taskList[index].deadline
                                          .toString()),
                                      Text(state.taskList[index].timeStamp!),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  editAlertDialog(
                                      context, state.taskList[index].id!);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _bloc.add(
                                    DeleteTaskEvent(
                                        id: state.taskList[index].id!),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox();
              });
        }
        return CircularProgressIndicator();
      },
    );
  }

  editAlertDialog(context, id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Изменения задачи"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Статус"),
                        DropdownButton(
                          value: homeBloc.dropdownValue,
                          onChanged: (value) {
                            homeBloc.dropdownValue = value.toString();
                            print(homeBloc.dropdownValue);
                          },
                          items: homeBloc.statusList.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _deadlineController,
                      decoration: InputDecoration(
                        labelText: 'Время на выполнения',
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
                var status;
                if (formKey.currentState!.validate()) {
                  if (homeBloc.dropdownValue == homeBloc.statusList[0]) {
                    status = 0;
                  } else if (homeBloc.dropdownValue == homeBloc.statusList[1]) {
                    status = 1;
                  } else if (homeBloc.dropdownValue == homeBloc.statusList[2]) {
                    status = 2;
                  }
                  BlocProvider.of<HomeBloc>(context).add(
                    UpdateTaskEvent(
                      id: id,
                      taskName: _taskNameController.text,
                      deadline: int.parse(_deadlineController.text),
                      status: status,
                    ),
                  );
                  _taskNameController.clear();
                  _deadlineController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Сохранить"),
            ),
          ],
        );
      },
    );
  }
}
