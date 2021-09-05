import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_task/models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  Future<Database?> get db async => _db ??= await initDb();

  static const version = 1;

  String taskTable = "tasks";

  String taskId = 'id';
  String taskName = 'task_name';
  String status = 'status';
  String deadline = 'deadline';
  String timeStamp = 'time_stamp';

  Future<Database> initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'taskApp.db';
    final todoListDb = await openDatabase(path,
        version: version, onCreate: _onCreatingDatabase);
    return todoListDb;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE $taskTable($taskId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$taskName TEXT, "
        "$status INTEGER, "
        "$deadline INTEGER, "
        "$timeStamp TEXT)");
  }

  Future getTaskMapList(String orderByStatus) async {
    print(orderByStatus);
    Database? db = await this.db;
    dynamic query = await db?.query(taskTable);
    if (orderByStatus == "ASC") {
      query = await db?.query(taskTable, orderBy: '$deadline ASC');
    } else if (orderByStatus == "DESC") {
      query = await db?.query(taskTable, orderBy: '$deadline DESC');
    } else {
      query = await db?.query(taskTable);
    }
    final List<Map<String, Object?>>? result = query;
    return result;
  }

  Future<List<Task>> getTaskList({String orderByStatus = "ASC"}) async {
    final List<Map<String, Object?>> taskMapList =
        await getTaskMapList(orderByStatus);
    final List<Task> taskList = [];
    taskMapList.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

  Future insertTask(Task task) async {
    Database? db = await this.db;
    final result = await db?.insert(taskTable, task.toMap());
    return result;
  }

  Future updateTask(Task task) async {
    Database? db = await this.db;
    final int? result = await db?.update(taskTable, task.toMap(),
        where: '$taskId = ?', whereArgs: [task.id]);
    return result;
  }

  Future deleteItem(table, id) async {
    Database? db = await this.db;
    return await db?.rawDelete("DELETE FROM $taskTable WHERE $taskId = $id");
  }
}
