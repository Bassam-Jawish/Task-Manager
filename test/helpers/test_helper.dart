import 'package:mockito/annotations.dart';
import 'package:task_manager_app/core/network/network_info.dart';
import 'package:task_manager_app/features/task_management/data/data_sources/remote/task_api_service.dart';
import 'package:task_manager_app/features/task_management/domain/repository/task_repo.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager_app/features/task_management/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/edit_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/get_task_usecase.dart';

@GenerateMocks(
  [
    TaskRepository,
    TaskApiService,
    GetTasksUseCase,
    AddTaskUseCase,
    EditTaskUseCase,
    DeleteTaskUseCase,
    NetworkInfo,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)

void main() {}