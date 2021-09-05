import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:todo_task/models/task.dart';
import 'package:todo_task/repositoriers/database_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());

  String dropdownValue = "Новый";
  List<String> statusList = ["Новый", "В процессе", "Выполнено"];

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    var _taskList;
    if (event is GetTasksEvent) {
      yield HomeInitial();
      try {
        _taskList = await DatabaseHelper.instance.getTaskList();
        yield LoadedTasksState(_taskList);
      } catch (e) {
        print(e);
      }
    }
    if (event is OrderByDeadlineEvent) {
      yield HomeInitial();
      _taskList = await DatabaseHelper.instance
          .getTaskList(orderByStatus: event.orderBy);
      yield LoadedTasksState(_taskList);
    }
    if (event is AddTaskEvent) {
      var timeStamp = DateFormat('dd-MM-yyyy – HH:mm').format(DateTime.now());
      Task task = Task(
          task: event.name, deadline: event.deadline, timeStamp: timeStamp);

      await DatabaseHelper.instance.insertTask(task);

      _taskList = await DatabaseHelper.instance.getTaskList();
      yield LoadedTasksState(_taskList);
    }
    if (event is UpdateTaskEvent) {
      Task task = Task(
        task: event.taskName,
        deadline: event.deadline,
        status: event.status!,
        id: event.id,
        timeStamp: DateFormat('dd-MM-yyyy – HH:mm').format(DateTime.now()),
      );
      await DatabaseHelper.instance.updateTask(task);

      _taskList = await DatabaseHelper.instance.getTaskList();
      yield LoadedTasksState(_taskList);
    }
    if (event is DeleteTaskEvent) {
      await DatabaseHelper.instance.deleteItem(event.tableName, event.id);
      var _taskList;
      _taskList = await DatabaseHelper.instance.getTaskList();
      yield LoadedTasksState(_taskList);
    }
  }
}
