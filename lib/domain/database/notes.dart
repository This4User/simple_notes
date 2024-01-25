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
    required this.expireIn,
    this.isNeedCreate = true,
    this.id,
  });

  final String? id;
  final String title;
  final String text;
  final List<String> tags;
  final String color;
  final DateTime? remindAt;
  final int? expireIn;
  final bool isNeedCreate;
}

Future<List<NoteDatabase>> getNotesFromDB() async {
  final assignmentsData = await IsarInstance.get.notes.where().findAll();

  return assignmentsData;
}

Future<void> clearNotesDB() async {
  await IsarInstance.get.writeTxn(() async {
    await IsarInstance.get.notes.clear();
  });
}

Future<void> deleteNoteFromDB(String id) async {
  await IsarInstance.get.writeTxn(() async {
    await IsarInstance.get.notes.deleteByRealId(id);
  });
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
    ..expiresIn = data.expireIn
    ..createdAt = DateTime.now()
    ..updatedAt = DateTime.now()
    ..isNeedSendCreate = data.isNeedCreate;

  IsarInstance.get.writeTxn(() async {
    if (data.id != null) {
      final prevIsNeedSendCreate =
          (await IsarInstance.get.notes.getByRealId(data.id!))
              ?.isNeedSendCreate;

      instance.isNeedSendCreate = prevIsNeedSendCreate ?? data.isNeedCreate;

      await IsarInstance.get.notes.putByRealId(instance);

      return;
    }

    instance.id = await IsarInstance.get.notes.put(instance);
  });

  return instance.realId;
}
