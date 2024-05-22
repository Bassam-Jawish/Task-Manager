import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../injection_container.dart';

////////////////////////////////////////////////////////////////////////////////

class SecureStorage {

  static FlutterSecureStorage? storage;

  static initStorage()
  {
    storage = FlutterSecureStorage(aOptions: _secureOption());
  }

  static AndroidOptions _secureOption() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<void>writeSecureData({required String key, required dynamic value}) async {
    await storage!.write(key: key, value: value.toString(),);
  }

  static dynamic readSecureData({required String key}) async {
    String value = await storage!.read(key: key) ?? 'No data found!';
    print('Data read from secure storage: $value');
    return value;
  }

  static Future<void>deleteSecureData({required String key}) async {
    await storage!.delete(key: key);
  }

  static Future<void>deleteAllSecureData() async {
    await storage!.delete(key: 'token');
    await storage!.delete(key: 'refresh_token');
    await storage!.delete(key: 'user_id');
    await storage!.delete(key: 'user_name');
    token = 'No data found!';
  }
}