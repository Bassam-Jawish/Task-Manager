
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repository/task_repo.dart';

class GetTasksUseCase implements UseCase<DataState<TasksInfoEntity>, GetTasksParams> {
  final TaskRepository taskRepository;

  GetTasksUseCase(this.taskRepository);

  @override
  Future<DataState<TasksInfoEntity>> call({GetTasksParams? params}) {
    return taskRepository.getTasks(params!.userId, params.limit, params.skip, params.isConnected);
  }

}

class GetTasksParams {
  final int userId;

  final int limit;

  final int skip;

  final bool isConnected;

  GetTasksParams({required this.userId, required this.limit, required this.skip, required this.isConnected});
}