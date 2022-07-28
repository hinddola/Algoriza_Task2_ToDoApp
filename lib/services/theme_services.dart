import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService{
  final box = GetStorage();
   final _key = 'isDarkMode' ;

   saveThemeToBox(bool isDarkMode) => box.write(_key, isDarkMode);
   bool loadThemeFromBox ()=> box.read(_key)??false;
   ThemeMode get theme => loadThemeFromBox()? ThemeMode.dark:ThemeMode.light;

   void switchTheme(){
     Get.changeThemeMode(loadThemeFromBox()?ThemeMode.light:ThemeMode.dark);
     saveThemeToBox(!loadThemeFromBox());
   }

}