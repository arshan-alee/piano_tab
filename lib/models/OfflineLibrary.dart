import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class OfflineLibrary {
  @HiveField(1)
  bool isLoggedIn;
  @HiveField(2)
  List<String> offlineLibrary;

  OfflineLibrary({
    bool? isLoggedIn,
    List<String>? offlineLibrary, // Make offlineLibrary nullable
  })  : isLoggedIn = isLoggedIn ?? false,
        offlineLibrary =
            offlineLibrary ?? []; // Set default value as an empty list
}
