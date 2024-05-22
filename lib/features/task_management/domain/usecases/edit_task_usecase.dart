
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/task_repo.dart';

class EditTaskUseCase implements UseCase<DataState<void>, EditTaskParams> {
  final TaskRepository taskRepository;

  EditTaskUseCase(this.taskRepository);

  @override
  Future<DataState<void>> call({EditTaskParams? params}) {
    return taskRepository.editTask(params!.taskId, params.isCompleted);
  }

}

class EditTaskParams {
  final int taskId;

  final bool isCompleted;
  EditTaskParams({required this.taskId, required this.isCompleted});
}