import 'package:hive/hive.dart';
import 'package:paino_tab/models/LoginModel.dart';

class Boxes{
  static Box<LoginModel> getUserBox()=> Hive.box<LoginModel>("hiveuser");
}