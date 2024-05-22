import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/task_repo.dart';

class AddTaskUseCase implements UseCase<DataState<void>, AddTaskParams> {
  final TaskRepository taskRepository;

  AddTaskUseCase(this.taskRepository);

  @override
  Future<DataState<void>> call({AddTaskParams? params}) {
    return taskRepository.addTask(
        params!.todo!, params.isCompleted, params.userId);
  }
}

class AddTaskParams {
  final String todo;
  final bool isCompleted;
  final int userId;

  AddTaskParams(
      {required this.todo, required this.isCompleted, required this.userId});
}
