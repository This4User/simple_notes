import "package:isar/isar.dart";
import "package:simple_notes/domain/collection/note.dart";
import "package:simple_notes/domain/database/instance.dart";
import "package:uuid/v8.dart";

class NoteDBParams {
  NoteDBParams({
    required this.title,
    required this.text,
    required this.tags,
    required this.color,
    required this.remindAt,
    required this.expireAt,
    this.id,
  });

  final String? id;
  final String title;
  final String text;
  final List<String> tags;
  final String color;
  final DateTime? remindAt;
  final DateTime? expireAt;
}

Future<List<NoteDatabase>> getNotesFromDB() async {
  final assignmentsData = await IsarInstance.get.notes.where().findAll();

  return assignmentsData;
}

String setNoteData(NoteDBParams data) {
  const uuid = UuidV8();

  final instance = NoteDatabase()
    ..realId = data.id ?? uuid.generate()
    ..title = data.title
    ..text = data.text
    ..tags = data.tags
    ..color = data.color
    ..remindAt = data.remindAt
    ..expireAt = data.expireAt
    ..createdAt = DateTime.now()
    ..updatedAt = DateTime.now();

  IsarInstance.get.writeTxnSync(() async {
    if (data.id != null) {
      IsarInstance.get.notes.putByRealIdSync(instance);

      return;
    }

    instance.id = await IsarInstance.get.notes.put(instance);
  });

  return instance.realId;
}
