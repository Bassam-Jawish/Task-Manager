import 'dart:io';

import 'package:equatable/equatable.dart';


class TasksInfoEntity extends Equatable {
  final int? total;
  final int? skip;
  final int? limit;
  final List<TaskEntity>? todos;


  const TasksInfoEntity({this.total,this.skip, this.limit, this.todos});

  @override
  List<Object?> get props => [total, skip, limit, todos];
}


class TaskEntity extends Equatable {
  final int? taskId;
  final String? todo;
  final bool? isCompleted;
  final int? userId;

  const TaskEntity({this.taskId,this.todo, this.isCompleted,this.userId});

  @override
  List<Object?> get props => [taskId,todo,isCompleted, userId];
}