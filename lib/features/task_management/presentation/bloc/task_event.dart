part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}

class GetTasks extends TaskEvent {
  final int userId;
  final int limit;
  final int skip;

  final bool isRefreshAll;

  const GetTasks(this.userId, this.limit, this.skip, this.isRefreshAll);

  @override
  List<Object> get props => [userId, limit, skip, isRefreshAll];
}

class AddTask extends TaskEvent {
  final String todo;
  final int userId;
  final bool isCompleted;

  const AddTask(this.todo, this.userId, this.isCompleted);

  @override
  List<Object> get props => [todo, userId, isCompleted];
}

class EditTask extends TaskEvent {

  final int taskId;
  final bool isCompleted;

  const EditTask(this.taskId, this.isCompleted);

  @override
  List<Object> get props => [isCompleted, taskId];
}

class DeleteTask extends TaskEvent {
  final int taskId;

  final int index;
  const DeleteTask(this.taskId, this.index);

  @override
  List<Object> get props => [taskId];
}

class ClearTaskController extends TaskEvent {
  const ClearTaskController();

  @override
  List<Object> get props => [];
}