import "package:isar/isar.dart";

part "note.g.dart";

@Collection(accessor: "notes")
class NoteDatabase {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String realId;
  late String title;
  late String text;
  late List<String> tags;
  late String color;
  late DateTime? remindAt;
  late int? expiresIn;
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isNeedSendCreate;
}
