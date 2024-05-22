
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task_manager_app/features/task_management/data/models/task_model.dart';


part 'task_api_service.g.dart';

@RestApi()
abstract class TaskApiService {
  factory TaskApiService(Dio dio) {
    return _TaskApiService(dio);
  }

  @GET('/todos/user/{userId}')
  Future<HttpResponse<TasksInfoModel>> getTasks(
      @Path('userId') int userId,
      @Query('limit') int limit,
      @Query('skip') int skip,
      );

  @POST('/todos/add')
  Future<HttpResponse<TaskModel>> addTask(
      @Field("todo") String todo,
      @Field("completed") bool isCompleted,
      @Field("userId") int userId,
      );

  @PUT('/todos/{taskId}')
  Future<HttpResponse<void>> editTask(
      @Path('taskId') int taskId,
      @Field("completed") bool isCompleted,
      );

  @DELETE('/todos/{taskId}')
  Future<HttpResponse<void>> deleteTask(
      @Path('taskId') int taskId,
      );
}