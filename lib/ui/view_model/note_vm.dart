import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:simple_notes/domain/database/notes.dart";
import "package:simple_notes/domain/model/note.dart";

part "note_vm.freezed.dart";

part "note_vm.g.dart";

@freezed
class NoteModel with _$NoteModel {
  const factory NoteModel({
    String? id,
    @Default("") String title,
    @Default("") String text,
    @Default("FBF8CC") String color,
  }) = _NoteModel;
}

@riverpod
class NoteVm extends _$NoteVm {
  @override
  NoteModel build() {
    return const NoteModel();
  }

  void initNote(Note data) {
    state = state.copyWith(
      id: data.id,
      title: data.title,
      text: data.text,
      color: data.color,
    );
  }

  Future<void> saveNote() async {
    await setNoteData(
      NoteDBParams(
        id: state.id,
        title: state.title,
        text: state.text,
        color: state.color,
      ),
    );
  }

  void updateTitle(String value) {
    state = state.copyWith(title: value);
  }

  void updateText(String value) {
    state = state.copyWith(text: value);
  }

  void updateColor(String value) {
    state = state.copyWith(color: value);
  }
}
