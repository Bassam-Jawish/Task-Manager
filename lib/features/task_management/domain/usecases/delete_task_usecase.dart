import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/task_repo.dart';

class DeleteTaskUseCase implements UseCase<DataState<void>, DeleteTaskParams> {
  final TaskRepository taskRepository;

  DeleteTaskUseCase(this.taskRepository);

  @override
  Future<DataState<void>> call({DeleteTaskParams? params}) {
    return taskRepository.deleteTask(params!.taskId);
  }
}

class DeleteTaskParams {
  final int taskId;

  DeleteTaskParams({required this.taskId});
}
