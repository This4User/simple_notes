import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:simple_notes/domain/collection/note.dart";

class IsarInstance {
  IsarInstance._();

  static late Isar _instance;
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (!_isInitialized) {
      final dir = await getApplicationDocumentsDirectory();

      _instance = await Isar.open(
        [NoteDatabaseSchema],
        directory: dir.path,
      );
      _isInitialized = true;
    } else {
      throw Exception("already initialized");
    }
  }

  static Isar get get => _instance;
}
