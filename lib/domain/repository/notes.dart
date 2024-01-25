import "package:simple_notes/api/notes.dart";
import "package:simple_notes/domain/database/notes.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/utils/date_time.dart";

Future<List<Note>> getAllNotes({bool isNeedUpdate = false}) async {
  if (isNeedUpdate) {
    return _syncNotes();
  }

  final notesData = await getNotesFromDB();

  return notesData
      .map(
        (e) => Note(
          id: e.realId,
          isNew: false,
          title: e.title,
          text: e.text,
          tags: e.tags,
          color: e.color,
          reminder: e.remindAt,
          expires: e.expiresIn,
        ),
      )
      .toList();
}

Future<List<Note>> _syncNotes() async {
  final apiNotesData = await sendGetAllNotes();

  await clearNotesDB();

  for (final e in apiNotesData) {
    setNoteData(
      NoteDBParams(
        id: e.id,
        title: e.title,
        text: e.text,
        tags: e.tags,
        color: e.color,
        remindAt: parseDateOrNull(e.reminder),
        expireIn: e.expires,
        isNeedCreate: false,
      ),
    );
  }

  return apiNotesData
      .map(
        (e) => Note(
          id: e.id,
          isNew: false,
          title: e.title,
          text: e.text,
          tags: e.tags,
          color: e.color,
          reminder: parseDateOrNull(e.reminder),
          expires: e.expires,
        ),
      )
      .toList();
}

Future<void> deleteNote(String? id) async {
  if (id == null) return;

  await deleteNoteFromDB(id);
  await sendDeleteNote(id);
}
