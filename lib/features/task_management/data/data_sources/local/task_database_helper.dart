import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/task.dart';
import '../../models/task_model.dart';

class TaskDatabaseHelper {
  static final TaskDatabaseHelper instance = TaskDatabaseHelper._init();

  static Database? _database;

  TaskDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER,
        todo TEXT,
        isCompleted INTEGER,
        userId INTEGER
      )
    ''');
  }

  Future<TaskEntity> insertTask(TaskEntity task) async {
    final db = await instance.database;
    final Map<String, dynamic> taskData = {
      'taskId': task.taskId,
      'todo': task.todo,
      'isCompleted': task.isCompleted! ? 1 : 0, // Convert bool to int
      'userId': task.userId,
    };
    final id = await db.insert('tasks', taskData);
    return TaskEntity(
      taskId: id,
      todo: task.todo,
      isCompleted: task.isCompleted,
      userId: task.userId,
    );
  }

  Future<int> updateTask(TaskEntity task) async {
    final db = await instance.database;
    final Map<String, dynamic> taskData = {
      'todo': task.todo,
      'isCompleted': task.isCompleted! ? 1 : 0, // Convert bool to int
      'userId': task.userId,
    };
    return await db.update('tasks', taskData,
        where: 'taskId = ?', whereArgs: [task.taskId]);
  }

  Future<int> deleteTask(int taskId) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'taskId = ?', whereArgs: [taskId]);
  }

  Future<List<TaskEntity>> getTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return TaskEntity(
        taskId: maps[i]['taskId'] as int?,
        todo: maps[i]['todo'] as String?,
        isCompleted: maps[i]['isCompleted'] == 1 ? true : false,
        userId: maps[i]['userId'] as int?,
      );
    });
  }
}
