import 'package:hive/hive.dart';

class HiveDB{
  static String DB_NAME = "note_app_with_firebase";
  static var box = Hive.box(DB_NAME);

  static Future<void> storeUserId(String userId) async{
    await box.put('userId', userId);
  }

  static String loadUserId() {
    var result = box.get("userId");
    return result;
  }

  static void removeUser(String userId) async{
    await box.delete(userId);
  }


}