import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';

import '../../../../core/app_export.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/edit_task_usecase.dart';
import '../../domain/usecases/get_task_usecase.dart';

part 'task_state.dart';

part 'task_event.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final EditTaskUseCase _editTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final NetworkInfo _networkInfo;

  TaskBloc(this._getTasksUseCase, this._addTaskUseCase, this._editTaskUseCase,
      this._deleteTaskUseCase, this._networkInfo)
      : super(TaskState().copyWith(
            taskStatus: TaskStatus.initial,
            isAddingTaskLoading: false,
            isEditingTaskPasswordLoading: false,
            isDeletingTaskLoading: false,
            isTasksLoaded: false,
            tasksEntity: [],
            scrollController: ScrollController(),
            taskController: TextEditingController())) {
    state.scrollController!.addListener(_scrollListener);
    on<GetTasks>(onGetTasks);
    on<AddTask>(onAddTask);
    on<EditTask>(onEditTask);
    on<DeleteTask>(onDeleteTask);
    on<ClearTaskController>(onClearTaskController);
  }

  Future<void> _scrollListener() async {
    if (state.tasksInfoEntity == null) return;

    final isConnected = await _networkInfo.isConnected;
    if (state.scrollController!.position.pixels ==
        state.scrollController!.position.maxScrollExtent && isConnected) {
      emit(state.copyWith(taskStatus: TaskStatus.paginated));
      // call get all discount
    }
  }

  @override
  Future<void> close() {
    state.scrollController!.dispose();
    return super.close();
  }

  Future<void> onGetTasks(GetTasks event, Emitter<TaskState> emit) async {
    if (event.isRefreshAll) {
      List<TaskEntity> taskList = [];
      emit(state.copyWith(isTasksLoaded: false, tasksEntity: taskList));
    }
    final bool isConnected = await _networkInfo.isConnected;

    /*if (!isConnected) {
      emit(state.copyWith(
        taskStatus: TaskStatus.errorShowTasks,
        error: ConnectionFailure('No Internet Connection'),
      ));
      return;
    }*/

    try {
      final getTasksParams = GetTasksParams(
          userId: event.userId, limit: event.limit, skip: event.skip , isConnected: isConnected);

      final dataState = await _getTasksUseCase(params: getTasksParams);

      if (dataState is DataSuccess) {

        List<TaskEntity> tasksList = event.isRefreshAll ? [] : state.tasksEntity!;
        tasksList!.addAll(dataState.data!.todos!);

        Map<int, bool> completedTasks = {};
        tasksList.forEach((element) {
          completedTasks!.addAll({
            element.taskId!: element.isCompleted!,
          });
        });

        emit(state.copyWith(
          taskStatus: TaskStatus.successShowTasks,
          tasksInfoEntity: dataState.data!,
          tasksEntity: tasksList,
          completedTasks: completedTasks,
          isTasksLoaded: true,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            taskStatus: TaskStatus.errorShowTasks,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          taskStatus: TaskStatus.errorShowTasks,
          error: ServerFailure.fromDioError(e)));
    }
  }

  Future<void> onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(taskStatus: TaskStatus.loadingAddTask));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        taskStatus: TaskStatus.errorAddTask,
        error: ConnectionFailure('No Internet Connection'),
      ));
      return;
    }

    /*List<TaskEntity> tasksList = state.tasksEntity!;
    tasksList.insert(0, TaskEntity(
      userId: event.userId,
      todov: event.todov,
      isCompleted: event.isCompleted,
    ));
    emit(state.copyWith(
      tasksEntity: tasksList,
    ));*/

    try {
      final addTaskParams = AddTaskParams(
          userId: event.userId,
          todo: event.todo,
          isCompleted: event.isCompleted);

      final dataState = await _addTaskUseCase(params: addTaskParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          taskStatus: TaskStatus.successAddTask,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            taskStatus: TaskStatus.errorAddTask,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          taskStatus: TaskStatus.errorAddTask,
          error: ServerFailure.fromDioError(e)));
    }
  }

  Future<void> onEditTask(EditTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(taskStatus: TaskStatus.loadingEditTask));

    Map<int, bool> completedTasks = state.completedTasks!;
    int id = event.taskId;
    completedTasks[id] = !completedTasks[id]!;

    List<TaskEntity> tasksList = state.tasksEntity!;
    List<TaskEntity> updatedTasksList = tasksList.map((task) {
      if (task.taskId == event.taskId) {
        return TaskEntity(
          taskId: task.taskId,
          todo: task.todo,
          isCompleted: true,
          userId: task.userId,
        );
      }
      return task;
    }).toList();

    emit(state.copyWith(
      completedTasks: completedTasks,
      tasksEntity: updatedTasksList
    ));

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        taskStatus: TaskStatus.errorEditTask,
        error: ConnectionFailure('No Internet Connection'),
      ));
      return;
    }

    try {
      final editTaskParams =
          EditTaskParams(taskId: event.taskId, isCompleted: event.isCompleted);

      final dataState = await _editTaskUseCase(params: editTaskParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          taskStatus: TaskStatus.successEditTask,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            taskStatus: TaskStatus.errorAddTask,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          taskStatus: TaskStatus.errorAddTask,
          error: ServerFailure.fromDioError(e)));
    }
  }

  Future<void> onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(state.copyWith(taskStatus: TaskStatus.loadingDeleteTask));

    state.tasksEntity!.removeAt(event.index);

    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      emit(state.copyWith(
        taskStatus: TaskStatus.errorDeleteTask,
        error: ConnectionFailure('No Internet Connection'),
      ));
      return;
    }

    try {
      final deleteTaskParams = DeleteTaskParams(taskId: event.taskId);

      final dataState = await _deleteTaskUseCase(params: deleteTaskParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(
          taskStatus: TaskStatus.successDeleteTask,
        ));
      }

      if (dataState is DataFailed) {
        debugPrint(dataState.error!.message);
        emit(state.copyWith(
            taskStatus: TaskStatus.errorDeleteTask,
            error: ServerFailure.fromDioError(dataState.error!)));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
          taskStatus: TaskStatus.errorDeleteTask,
          error: ServerFailure.fromDioError(e)));
    }
  }

  void onClearTaskController(
      ClearTaskController event, Emitter<TaskState> emit) {
    TextEditingController copy = state.taskController!;
    //copy.text = '';
    emit(state.copyWith(
        taskController: copy, taskStatus: TaskStatus.clearController));
  }
}
