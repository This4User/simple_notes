import "package:isar/isar.dart";
import "package:simple_notes/domain/collection/note.dart";
import "package:simple_notes/domain/database/instance.dart";
import "package:uuid/v8.dart";

class NoteDBParams {
  NoteDBParams({
    required this.title,
    required this.text,
    required this.color,
    this.id,
  });

  final String? id;
  final String title;
  final String text;
  final String color;
}

Future<List<NoteDatabase>> getNotesFromDB() async {
  final assignmentsData = await IsarInstance.get.notes.where().findAll();

  return assignmentsData;
}

Future<void> setNoteData(NoteDBParams data) async {
  const uuid = UuidV8();

  final instance = NoteDatabase()
    ..realId = data.id ?? uuid.generate()
    ..title = data.title
    ..text = data.text
    ..color = data.color
    ..createdAt = DateTime.now()
    ..updatedAt = DateTime.now();

  await IsarInstance.get.writeTxn(() async {
    if (data.id != null) {
      await IsarInstance.get.notes.putByRealId(instance);

      return;
    }

    instance.id = await IsarInstance.get.notes.put(instance);
  });
}
