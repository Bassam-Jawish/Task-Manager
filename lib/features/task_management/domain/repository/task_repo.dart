import '../../../../core/resources/data_state.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  // API methods
  Future<DataState<TasksInfoEntity>> getTasks(int userId, int limit, int skip, bool isConnected);
  Future<DataState<void>> addTask(String todo, bool isCompleted, int userId);
  Future<DataState<void>> editTask(int taskId, bool isCompleted);
  Future<DataState<void>> deleteTask(int taskId);

}
