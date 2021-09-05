part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class GetTasksEvent extends HomeEvent {}

class AddTaskEvent extends HomeEvent {
  final String name;
  final int deadline;

  AddTaskEvent({required this.name, required this.deadline});
}

class UpdateTaskEvent extends HomeEvent {
  late int deadline;
  late String taskName;
  int? status;
  final int id;

  UpdateTaskEvent(
      {required this.id,
      required this.deadline,
      required this.taskName,
      required this.status});
}

class DeleteTaskEvent extends HomeEvent {
  String tableName;
  final int id;

  DeleteTaskEvent({this.tableName = "tasks", required this.id});
}

class OrderByDeadlineEvent extends HomeEvent {
  late String orderBy;

  OrderByDeadlineEvent(this.orderBy);
}
