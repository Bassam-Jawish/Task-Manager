import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:task_manager_app/config/config.dart';
import 'package:task_manager_app/features/task_management/data/data_sources/remote/task_api_service.dart';
import 'package:task_manager_app/features/task_management/data/models/task_model.dart';
import '../../helpers/json_reader.dart';

class MockDio extends Mock implements HttpClientAdapter {}
/*
void main () {

  late TaskApiServiceImp taskApiServiceImp;
  late MockDio mockDio;
  final Dio tdio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );

  setUp((){
    mockDio = MockDio();
    tdio.httpClientAdapter = mockDio;
    taskApiServiceImp = TaskApiServiceImp(tdio);
  });

  test('should return task info model when the response code is 200 or 201', () async {
    // arrange
    final responsePayload = readJson('helpers/dummy_data/dummy_task_response.json');
    final httpResponse = ResponseBody.fromString(
      responsePayload,
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

    when(mockDio.fetch(RequestOptions(
      path: '/todos/user/15',
    ), any, any))
        .thenAnswer((_) async => httpResponse);

    // Act
    final response = await taskApiServiceImp.getTasks(15, 1, 0);

    // Assert
    final expected = TasksInfoModel.fromJson({
      "todos": [
        {"id": 1, "todo": "Create a compost pile", "completed": false, "userId": 15},
      ],
      "total": 3,
      "skip": 0,
      "limit": 1
    });

    expect(response.data, equals(expected));
  });

}*/