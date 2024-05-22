import 'package:dio/dio.dart';
import 'package:dio/src/dio_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/error/failure.dart';
import 'package:task_manager_app/core/resources/data_state.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/get_task_usecase.dart';
import 'package:task_manager_app/features/task_management/presentation/bloc/task_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';


void main() {
  late TaskBloc taskBloc;
  late MockGetTasksUseCase mockGetTasksUseCase;
  late MockAddTaskUseCase mockAddTaskUseCase;
  late MockEditTaskUseCase mockEditTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockGetTasksUseCase = MockGetTasksUseCase();
    mockAddTaskUseCase = MockAddTaskUseCase();
    mockEditTaskUseCase = MockEditTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockNetworkInfo = MockNetworkInfo();
    taskBloc = TaskBloc(
      mockGetTasksUseCase,
      mockAddTaskUseCase,
      mockEditTaskUseCase,
      mockDeleteTaskUseCase,
      mockNetworkInfo,
    );
  });

  test('Initial state of TaskBloc should be correct', () {
    expect(taskBloc.state.accessToken, isNull);
    expect(taskBloc.state.error, isNull);
    expect(taskBloc.state.tasksInfoEntity, isNull);
    expect(taskBloc.state.isShowLoading, isNull);
    expect(taskBloc.state.taskStatus, TaskStatus.initial);
    expect(taskBloc.state.isAddingTaskLoading, false);
    expect(taskBloc.state.isEditingTaskPasswordLoading, false);
    expect(taskBloc.state.isDeletingTaskLoading, false);
    expect(taskBloc.state.taskController, isNotNull);
    expect(taskBloc.state.scrollController, isNotNull);
    expect(taskBloc.state.isTasksLoaded, false);
    expect(taskBloc.state.tasksEntity, isEmpty);
    expect(taskBloc.state.completedTasks, isNull);
  });

  tearDown(() {
    taskBloc.close();
  });


  // code

  group('TaskEvent', () {
    test('GetTasks props are correct', () {
      final event = GetTasks(1, 10, 0, true);
      expect(event.props, [1, 10, 0, true]);
    });

    test('AddTask props are correct', () {
      final event = AddTask('Test Task', 1, false);
      expect(event.props, ['Test Task', 1, false]);
    });

    test('EditTask props are correct', () {
      final event = EditTask(1, true);
      expect(event.props, [true, 1]);
    });

    test('DeleteTask props are correct', () {
      final event = DeleteTask(1, 0);
      expect(event.props, [1]);
    });

    test('ClearTaskController props are correct', () {
      final event = ClearTaskController();
      expect(event.props, []);
    });

    test('GetTasks equality', () {
      expect(
        GetTasks(1, 10, 0, true),
        equals(GetTasks(1, 10, 0, true)),
      );
    });

    test('AddTask equality', () {
      expect(
        AddTask('Test Task', 1, false),
        equals(AddTask('Test Task', 1, false)),
      );
    });

    test('EditTask equality', () {
      expect(
        EditTask(1, true),
        equals(EditTask(1, true)),
      );
    });

    test('DeleteTask equality', () {
      expect(
        DeleteTask(1, 0),
        equals(DeleteTask(1, 0)),
      );
    });

    test('ClearTaskController equality', () {
      expect(
        ClearTaskController(),
        equals(ClearTaskController()),
      );
    });
  });


  group('GetTasks', () {
    const userId = 1;
    const limit = 10;
    const skip = 0;
    const isRefreshAll = true;

    final tasks = [
      TaskEntity(taskId: 1, todo: 'Task 1', isCompleted: false),
      TaskEntity(taskId: 2, todo: 'Task 2', isCompleted: true),
    ];

    final tasksInfoEntity = TasksInfoEntity(todos: tasks);

    blocTest<TaskBloc, TaskState>(
      'emits [loadingShowTasks, successShowTasks] when GetTasks is successful',
      build: () {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockGetTasksUseCase(params: GetTasksParams(userId: userId, limit: limit, skip: skip, isConnected: true)))
            .thenAnswer((_) async => DataSuccess(tasksInfoEntity));
        return taskBloc;
      },
      act: (bloc) => bloc.add(GetTasks(userId, limit, skip, isRefreshAll)),
      expect: () => [
        taskBloc.state.copyWith(
          isTasksLoaded: false,
          tasksEntity: [],
        ),
        taskBloc.state.copyWith(
          taskStatus: TaskStatus.successShowTasks,
          tasksInfoEntity: tasksInfoEntity,
          tasksEntity: tasks,
          completedTasks: {1: false, 2: true},
          isTasksLoaded: true,
        ),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [loadingShowTasks, errorShowTasks] when GetTasks fails',
      build: () {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockGetTasksUseCase(params: GetTasksParams(userId: userId, limit: limit, skip: skip, isConnected: true)))
            .thenAnswer((_) async => DataFailed(DioException(requestOptions: RequestOptions(path: ''))));
        return taskBloc;
      },
      act: (bloc) => bloc.add(GetTasks(userId, limit, skip, isRefreshAll)),
      expect: () => [
        taskBloc.state.copyWith(
          isTasksLoaded: false,
          tasksEntity: [],
        ),
        taskBloc.state.copyWith(
          taskStatus: TaskStatus.errorShowTasks,
          error: ServerFailure('Server Error'),
        ),
      ],
    );
  });

}
