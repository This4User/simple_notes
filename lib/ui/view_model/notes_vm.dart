import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:simple_notes/domain/collection/note.dart";
import "package:simple_notes/domain/database/instance.dart";
import "package:simple_notes/domain/database/notes.dart";
import "package:simple_notes/domain/model/note.dart";

part "notes_vm.freezed.dart";

part "notes_vm.g.dart";

@freezed
class NotesModel with _$NotesModel {
  const factory NotesModel({
    @Default(0) int totalCount,
    @Default([]) List<Note> items,
  }) = _NotesModel;
}

@riverpod
class NotesVm extends _$NotesVm {
  @override
  NotesModel build() {
    init();
    IsarInstance.get.notes.watchLazy().listen((_) => init());

    return const NotesModel();
  }

  Future<void> init() async {
    final notesData = await getNotesFromDB();

    state = state.copyWith(
      items: notesData
          .map(
            (e) => Note(
              id: e.realId,
              title: e.title,
              text: e.text,
              color: e.color,
            ),
          )
          .toList(),
    );
  }

  Note getById(String id) {
    return state.items.firstWhere((note) => note.id == id);
  }
}
