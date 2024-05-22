import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/features/task_management/data/models/task_model.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';

import '../../helpers/json_reader.dart';

void main() {
  const testTasksInfoModel = TasksInfoModel(
    total: 3,
    skip: 0,
    limit: 1,
    todos: [
      TaskModel(
        taskId: 1,
        todo: 'Create a compost pile',
        isCompleted: true,
        userId: 15,
      ),
    ],
  );


  test('should be a subclass of task info entity', () async {
    //assert
    expect(testTasksInfoModel, isA<TasksInfoEntity>());
  });

  test('should return a valid model from json', () async {
    //arrange
    final Map<String, dynamic> jsonMap = json.decode(
      readJson('helpers/dummy_data/dummy_task_response.json'),
    );

    //act
    final result = TasksInfoModel.fromJson(jsonMap);

    //assert
    expect(result, equals(testTasksInfoModel));
  });

  test(
    'should return a json map containing proper data',
        () async {
      // arrange
      final result = testTasksInfoModel.toJson();

      // act
      final expectedJsonMap = {
        "todos": [
          {
            "id": 1,
            "todo": "Create a compost pile",
            "completed": true,
            "userId": 15
          }
        ],
        "total": 3,
        "skip": 0,
        "limit": 1
      };
      // assert
      expect(result, equals(expectedJsonMap));
    },
  );
}
