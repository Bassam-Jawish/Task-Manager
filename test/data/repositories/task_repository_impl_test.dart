import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:task_manager_app/core/resources/data_state.dart';
import 'package:task_manager_app/features/task_management/data/models/task_model.dart';
import 'package:task_manager_app/features/task_management/data/repository/task_repo_impl.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TaskRepositoryImpl taskRepositoryImpl;
  late MockTaskApiService mockTaskApiService;

  setUp(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    mockTaskApiService = MockTaskApiService();
    taskRepositoryImpl = TaskRepositoryImpl(mockTaskApiService);
  });

  group('Get Tasks', () {
    final TasksInfoModel tasksInfoModel = TasksInfoModel(
      todos: [
        TaskModel(taskId: 1, userId: 15, todo: 'Task 1', isCompleted: true),
      ],
      limit: 1,
      total: 3,
      skip: 0,
    );

    test('should return user tasks when a call to data source is successful',
        () async {
      // arrange
      when(mockTaskApiService.getTasks(15, 1, 0))
          .thenAnswer((_) async => HttpResponse(
                tasksInfoModel,
                Response(
                  requestOptions: RequestOptions(
                      path: 'https://dummyjson.com/todos/user/15'),
                  data: readJson('helpers/dummy_data/dummy_task_response.json'),
                  statusCode: 200,
                ),
              ));

      // act
      final result = await taskRepositoryImpl.getTasks(15, 1, 0, true);

      // assert
      expect(result, isA<DataSuccess<TasksInfoEntity>>());
      expect(
          (result as DataSuccess<TasksInfoEntity>).data, isA<TasksInfoModel>());
    });

    test(
      'should return server failure when a call to data source is unsuccessful',
      () async {
        //arrange
        when(mockTaskApiService.getTasks(15, 1, 0))
            .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

        //act
        final result = await taskRepositoryImpl.getTasks(15, 1, 0, true);

        //assert
        expect(result, isA<DataFailed<TasksInfoEntity>>());
      },
    );
  });
}
