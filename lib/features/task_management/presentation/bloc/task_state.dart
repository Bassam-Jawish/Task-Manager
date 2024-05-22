part of 'task_bloc.dart';

enum TaskStatus {
  initial,
  loadingAddTask,
  successAddTask,
  errorAddTask,
  loadingEditTask,
  successEditTask,
  errorEditTask,
  loadingShowTasks,
  successShowTasks,
  errorShowTasks,
  loadingDeleteTask,
  successDeleteTask,
  errorDeleteTask,
  clearController,
  paginated,
}

class TaskState extends Equatable {
  final String? accessToken;
  final Failure? error;
  final TasksInfoEntity? tasksInfoEntity;
  final bool? isShowLoading;
  final TaskStatus? taskStatus;
  final bool? isAddingTaskLoading;
  final bool? isEditingTaskPasswordLoading;
  final bool? isDeletingTaskLoading;

  final TextEditingController? taskController;

  final ScrollController? scrollController;

  final bool? isTasksLoaded;

  final List<TaskEntity>? tasksEntity;

  final Map<int, bool>? completedTasks;

  const TaskState(
      {this.accessToken,
      this.tasksInfoEntity,
      this.error,
      this.taskStatus,
      this.isAddingTaskLoading,
      this.isDeletingTaskLoading,
      this.isEditingTaskPasswordLoading,
      this.isShowLoading,
      this.taskController,
      this.scrollController,
      this.tasksEntity,
      this.completedTasks,
      this.isTasksLoaded});

  TaskState copyWith({
    String? accessToken,
    Failure? error,
    TasksInfoEntity? tasksInfoEntity,
    TaskStatus? taskStatus,
    bool? isAddingTaskLoading,
    bool? isDeletingTaskLoading,
    bool? isEditingTaskPasswordLoading,
    bool? isShowLoading,
    TextEditingController? taskController,
    ScrollController? scrollController,
    List<TaskEntity>? tasksEntity,
    final Map<int, bool>? completedTasks,
    bool? isTasksLoaded,
  }) =>
      TaskState(
        accessToken: accessToken ?? this.accessToken,
        tasksInfoEntity: tasksInfoEntity ?? this.tasksInfoEntity,
        error: error ?? this.error,
        taskStatus: taskStatus ?? this.taskStatus,
        isAddingTaskLoading: isAddingTaskLoading ?? this.isAddingTaskLoading,
        isDeletingTaskLoading:
            isDeletingTaskLoading ?? this.isDeletingTaskLoading,
        isEditingTaskPasswordLoading:
            isEditingTaskPasswordLoading ?? this.isEditingTaskPasswordLoading,
        isShowLoading: isShowLoading ?? this.isShowLoading,
        taskController: taskController ?? this.taskController,
        scrollController: scrollController ?? this.scrollController,
        tasksEntity: tasksEntity ?? this.tasksEntity,
        completedTasks: completedTasks ?? this.completedTasks,
        isTasksLoaded: isTasksLoaded ?? this.isTasksLoaded,
      );

  @override
  List<Object?> get props => [
        accessToken,
        tasksInfoEntity,
        error,
        taskStatus,
        isAddingTaskLoading,
        isDeletingTaskLoading,
        isEditingTaskPasswordLoading,
        isShowLoading,
        taskController,
        scrollController,
        tasksEntity,
        completedTasks,
        isTasksLoaded
      ];
}
