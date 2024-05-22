import '../../domain/entities/task.dart';

class TasksInfoModel extends TasksInfoEntity {
  const TasksInfoModel({
    int? total,
    int? skip,
    int? limit,
    List<TaskModel>? todos,
  }) : super(
          total: total,
          skip: skip,
          limit: limit,
          todos: todos,
        );

  factory TasksInfoModel.fromJson(Map<String, dynamic> map) {
    return TasksInfoModel(
      total: map['total'] ?? 0,
      skip: map['skip'] ?? 0,
      limit: map['limit'] ?? 0,
      todos: map['todos'] != null
          ? List<TaskModel>.from((map['todos'] as List)
          .map((task) => TaskModel.fromJson(task)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'skip': skip,
      'limit': limit,
      'todos': todos?.map((e) => e).toList(),
    };
  }
}

class TaskModel extends TaskEntity {
  const TaskModel({
    int? taskId,
    String? todo,
    bool? isCompleted,
    int? userId,
  }) : super(
          taskId: taskId,
          todo: todo,
          isCompleted: isCompleted,
          userId: userId,
        );

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['id'] ?? 0,
      todo: map['todo'] ?? "",
      isCompleted: map['completed'] ?? false,
      userId: map['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': taskId,
      'todo': todo,
      'completed': isCompleted,
      'userId': userId,
    };
  }

  TaskModel copy({int? id}) {
    return TaskModel(
      taskId: id ?? this.taskId,
      todo: this.todo,
      isCompleted: this.isCompleted,
      userId: this.userId,
    );
  }
}
