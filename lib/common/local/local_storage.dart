import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static set(String key,value) async{
    SharedPreferences instance=await SharedPreferences.getInstance();
    instance.setString(key, value);
  }
  static get(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.get(key);
  }

  static remove(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove(key);
  }
}