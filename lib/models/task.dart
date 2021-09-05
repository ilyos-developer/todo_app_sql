class Task {
  int? id;
  late String task;
  late int status;
  late int deadline;
  String? timeStamp;

  Task({
    this.id,
    required this.task,
    required this.deadline,
    this.timeStamp,
    this.status = 0,
  });

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['task_name'] = task;
    map['status'] = status;
    map['deadline'] = deadline;
    map['time_stamp'] = timeStamp;
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        task: map['task_name'],
        deadline: map['deadline'],
        timeStamp: map['time_stamp'],
        status: map['status']);
  }
}
