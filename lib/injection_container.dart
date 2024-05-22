import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager_app/features/task_management/data/data_sources/remote/task_api_service.dart';
import 'package:task_manager_app/features/task_management/data/repository/task_repo_impl.dart';
import 'package:task_manager_app/features/task_management/domain/repository/task_repo.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/add_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/edit_task_usecase.dart';
import 'package:task_manager_app/features/task_management/domain/usecases/get_task_usecase.dart';
import 'package:task_manager_app/features/task_management/presentation/bloc/task_bloc.dart';

import 'config/config.dart';
import 'core/app_export.dart';
import 'core/network/network_info.dart';
import 'core/utils/bloc_observer.dart';
import 'core/utils/cache_helper.dart';
import 'features/authentication/data/data_sources/remote/auth_api_service.dart';
import 'features/authentication/data/repository/auth_repo_impl.dart';
import 'features/authentication/domain/repository/auth_repo.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

// define main variables

String appName = '';

String packageName = '';

String version = '';

String buildNumber = '';

var token;

String name = "No data found!";

String image = "No data found!";

int limit = 5;

int skip = 0;

int? userId;

var isOnboarding = "No data found!";

Future<void> initializeDependencies() async {
  // Bloc Observer

  Bloc.observer = MyBlocObserver();

  // Secure Storage

  SecureStorage.initStorage();

  // Variables getting

  token = await SecureStorage.readSecureData(key: 'token');

  String result = await SecureStorage.readSecureData(key: 'userId');
  if (result == "No data found!") {
    userId = null;
  } else {
    userId = int.parse(result);
  }

  name = (await SecureStorage.readSecureData(key: 'name'));

  image = (await SecureStorage.readSecureData(key: 'image'));

  isOnboarding = await SecureStorage.readSecureData(key: 'isOnboarding');

  debugPrint('token=$token');
  debugPrint('userId=$userId');
  debugPrint('name=$name');
  debugPrint('onboarding=$isOnboarding');

  // App Info

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  version = packageInfo.version;
  buildNumber = packageInfo.buildNumber;

  // Dio
  Dio dio = Dio(
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

  // Access and Refresh Token
  // dio.interceptors.add(AuthInterceptor(dio));

  // init dio
  sl.registerSingleton<Dio>(dio);

  // Dependencies (Services)

  sl.registerSingleton<AuthApiService>(AuthApiService(sl()));
  sl.registerSingleton<TaskApiService>(TaskApiService(sl()));

  // Repositories

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl(sl()));
  sl.registerSingleton<TaskRepository>(TaskRepositoryImpl(sl()));

  // UseCases

  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<GetTasksUseCase>(GetTasksUseCase(sl()));
  sl.registerSingleton<AddTaskUseCase>(AddTaskUseCase(sl()));
  sl.registerSingleton<EditTaskUseCase>(EditTaskUseCase(sl()));
  sl.registerSingleton<DeleteTaskUseCase>(DeleteTaskUseCase(sl()));

  // Network
  sl.registerSingleton<NetworkInfo>(
    NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Bloc
  sl.registerFactory<AuthBloc>(
      () => AuthBloc(sl<LoginUseCase>(), sl<NetworkInfo>()));
  sl.registerFactory<TaskBloc>(() => TaskBloc(
      sl<GetTasksUseCase>(),
      sl<AddTaskUseCase>(),
      sl<EditTaskUseCase>(),
      sl<DeleteTaskUseCase>(),
      sl<NetworkInfo>()));
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

Future<void> initLocalDatabase() async {
  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, 'task_manager.db');

  final Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY,
          taskId INTEGER,
          todo TEXT,
          isCompleted INTEGER,
          userId INTEGER
        )
      ''');
    },
  );

  sl.registerSingleton<Database>(database);
}
