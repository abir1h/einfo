// import 'package:shared_preferences/shared_preferences.dart';
//
// // class LocalStorageServiceWithGetX extends GetxService {
// //   final SharedPreferences _sharedPreferences;
// //   LocalStorageServiceWithGetX({SharedPreferences? sharedPreferences})
// //       : _sharedPreferences = sharedPreferences!;
// //
// //   static LocalStorageServiceWithGetX? _instance;
// //   static Future<LocalStorageServiceWithGetX> initialize() async {
// //     return _instance ??
// //         LocalStorageServiceWithGetX(
// //             sharedPreferences: await SharedPreferences.getInstance());
// //   }
// //
// //   storeStringValue(String key, String value) async {
// //     _sharedPreferences.setString(key, value);
// //   }
// //
// //   storeBooleanValue(String key, bool value) async {
// //     _sharedPreferences.setBool(key, value);
// //   }
// //
// //   storeIntValue(String key, int value) async {
// //     _sharedPreferences.setInt(key, value);
// //   }
// //
// //   clearAllValues() async {
// //     _sharedPreferences.clear();
// //   }
// //
// //   String? getStringValue(String key) => _sharedPreferences.getString(key);
// //   bool? getBooleanValue(String key) => _sharedPreferences.getBool(key);
// //   int? getIntValue(String key) => _sharedPreferences.getInt(key);
// // }
//
// class LocalStorageService {
//   final SharedPreferences _sharedPreferences;
//   LocalStorageService({SharedPreferences? sharedPreferences})
//       : _sharedPreferences = sharedPreferences!;
//
//   static LocalStorageService? _instance;
//   static Future<LocalStorageService> getInstance() async {
//     return _instance ??
//         LocalStorageService(
//             sharedPreferences: await SharedPreferences.getInstance());
//   }
//
//   storeStringValue(String key, String value) async {
//     _sharedPreferences.setString(key, value);
//   }
//
//   storeBooleanValue(String key, bool value) async {
//     _sharedPreferences.setBool(key, value);
//   }
//
//   storeIntValue(String key, int value) async {
//     _sharedPreferences.setInt(key, value);
//   }
//
//   clearAllValues() async {
//     _sharedPreferences.clear();
//   }
//
//   String? getStringValue(String key) => _sharedPreferences.getString(key);
//   bool? getBooleanValue(String key) => _sharedPreferences.getBool(key);
//   int? getIntValue(String key) => _sharedPreferences.getInt(key);
// }
