import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyColors {

  static Color greenPolyTech = Color.fromARGB(255, 50, 170, 58);
  static Color gray94 = Color.fromARGB(255, 94, 94, 94);
  static Color gray165 = Color.fromARGB(255, 165, 165, 165);
  static Color gray77Opacity07 = Color.fromRGBO(77, 77, 77, 0.7);
  static Color gray216 = Color.fromARGB(255, 216, 216, 216);
  static Color gray77 = Color.fromARGB(255, 77, 77, 77);
  static Color blackOpacity03 = Color.fromRGBO(0, 0, 0, 0.3);
  static Color gray240 = Color.fromARGB(255, 240, 240, 240);
  static Color gray237 = Color.fromARGB(255, 237, 237, 237);
  static Color gray237Opacity07 = Color.fromRGBO(237, 237, 237, 0.7);
  static Color darkBackground = Color.fromARGB(255, 59, 61, 75);
  static Color darkAppBar = Color.fromARGB(255, 39, 41, 56);
  static Color lightAppBar = Color.fromARGB(255, 250, 250, 250);
  static Color yellowEat = Color.fromARGB(255, 247, 181, 0);
  static Color lightBluePrint = Color.fromARGB(255, 50, 197, 255);
  static Color redDirectory = Color.fromARGB(255, 224, 32, 32);
  static Color purpleLibrary = Color.fromARGB(255, 98, 54, 255);
  static Color blueLaboratory = Color.fromARGB(255, 2, 108, 187);
  static Color chocolate = Color.fromARGB(255, 106, 82, 55);
  static Color greenOffice = Color.fromARGB(255, 50, 146, 45);

  static Future<bool> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isDark') ?? false;
  }

  static Future<bool> setTheme(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool('isDark', value);
  }
}