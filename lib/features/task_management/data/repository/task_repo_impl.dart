import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_manager_app/features/task_management/data/models/task_model.dart';
import 'package:task_manager_app/features/task_management/domain/entities/task.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/repository/task_repo.dart';
import '../data_sources/local/task_database_helper.dart';
import '../data_sources/remote/task_api_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApiService _taskApiService;

  TaskRepositoryImpl(this._taskApiService);

  @override
  Future<DataState<TasksInfoEntity>> getTasks(
      int userId, int limit, int skip, bool isConnected) async {
    try {
      if (!isConnected) {
        // Getting local data here
        final localTasks = await TaskDatabaseHelper.instance.getTasks();
        if (localTasks.isNotEmpty) {
          return DataSuccess(TasksInfoEntity(todos: localTasks));
        }
      }

      final httpResponse = await _taskApiService.getTasks(userId, limit, skip);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        final TasksInfoModel model = httpResponse.data;
        final TasksInfoEntity entity = model;

        // save data to local
        entity.todos?.forEach((task) async {
          await TaskDatabaseHelper.instance.insertTask(task);
        });

        return DataSuccess(entity);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> addTask(
      String todo, bool isCompleted, int userId) async {
    try {
      final httpResponse =
          await _taskApiService.addTask(todo, isCompleted, userId);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        // adding to local database
        final TaskEntity addedTask = httpResponse.data;
        await TaskDatabaseHelper.instance.insertTask(addedTask);

        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> editTask(int taskId, bool isCompleted) async {
    try {
      final httpResponse = await _taskApiService.editTask(taskId, isCompleted);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        // editing local database
        await TaskDatabaseHelper.instance.updateTask(
          TaskEntity(taskId: taskId, isCompleted: isCompleted),
        );

        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> deleteTask(int taskId) async {
    try {
      final httpResponse = await _taskApiService.deleteTask(taskId);

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        // deleting local database
        await TaskDatabaseHelper.instance.deleteTask(taskId);

        return DataSuccess(httpResponse);
      } else {
        return DataFailed(DioException(
          error: httpResponse.response.statusMessage,
          response: httpResponse.response,
          type: DioExceptionType.badResponse,
          requestOptions: httpResponse.response.requestOptions,
        ));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }
}
