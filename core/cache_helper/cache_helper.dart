import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ملف يحتوي على مفاتيح التخزين
// import 'package:.../core/cache_helper/cache_values.dart';
class CacheKeys {
  static const String currentLanguage = 'currentLanguage';
}


/// كلاس مساعد لإدارة التخزين المحلي باستخدام SharedPreferences و FlutterSecureStorage.
/// يجب استدعاء `CacheHelper.init()` في ملف main.dart قبل تشغيل التطبيق.
class CacheHelper {
  CacheHelper._();

  static SharedPreferences? _sharedPreferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static void _checkInstance() {
    if (_sharedPreferences == null) {
      throw Exception(
          "CacheHelper not initialized. Call CacheHelper.init() in your main.dart");
    }
  }

  /// --- Language Management ---

  static Future<void> setLanguage(String langCode) async {
    await set(CacheKeys.currentLanguage, langCode);
  }

  static String getLanguage() {
    return get<String>(CacheKeys.currentLanguage) ?? 'en';
  }

  static bool isEnglish() => getLanguage() == 'en';


  /// --- Generic SharedPreferences Methods ---

  static Future<bool> set(String key, dynamic value) async {
    _checkInstance();
    if (value is String) return await _sharedPreferences!.setString(key, value);
    if (value is int) return await _sharedPreferences!.setInt(key, value);
    if (value is bool) return await _sharedPreferences!.setBool(key, value);
    if (value is double) return await _sharedPreferences!.setDouble(key, value);
    return false; // نوع غير مدعوم
  }

  static T? get<T>(String key) {
    _checkInstance();
    try {
      return _sharedPreferences!.get(key) as T?;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    _checkInstance();
    return await _sharedPreferences!.remove(key);
  }

  static Future<bool> clear() async {
    _checkInstance();
    return await _sharedPreferences!.clear();
  }


  /// --- Secure Storage Methods ---

  static Future<void> setSecured(String key, String value) async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Writing key: $key');
    }
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecured(String key) async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Reading key: $key');
    }
    return await _secureStorage.read(key: key);
  }
  
  static Future<void> removeSecured(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearSecured() async {
    if (kDebugMode) {
      print('FlutterSecureStorage: Clearing all data');
    }
    await _secureStorage.deleteAll();
  }
}
