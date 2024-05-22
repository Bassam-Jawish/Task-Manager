import 'package:mockito/mockito.dart';
import 'package:task_manager_app/core/resources/data_state.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/get_task_usecase.dart';

import '../../helpers/test_helper.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GetTasksUseCase getTasksUseCase;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    getTasksUseCase = GetTasksUseCase(mockTaskRepository!);
  });

  // Entity
  const testGetTaskEntity = TasksInfoEntity(
    todos: [
      TaskEntity(
        userId: 15,
        todo: 'specificTodo',
        isCompleted: false,
        taskId: 1,
      ),
    ],
    total: 3,
    skip: 0,
    limit: 1
  );

  // Params;
  final GetTasksParams getTasksParams =
  GetTasksParams(userId: 15, limit: 5, skip: 0, isConnected: true);

  test('should get tasks by userId', () async {
    // arrange

    when(mockTaskRepository!.getTasks(15, 5, 0, true)).thenAnswer(
            (realInvocation) async => const DataSuccess(testGetTaskEntity));

    // act

    final result = await getTasksUseCase?.call(params: getTasksParams);

    // assert

    expect(result, const DataSuccess(testGetTaskEntity));
  });
}