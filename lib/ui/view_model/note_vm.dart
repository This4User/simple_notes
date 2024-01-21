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
    @Default([]) List<String> tags,
    @Default(null) DateTime? remindAt,
    @Default(null) DateTime? expireAt,
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
      tags: data.tags,
      color: data.color,
      remindAt: data.remindAt,
      expireAt: data.expireAt,
    );
  }

  void saveNote() {
    if (state.text.isEmpty) return;

    state = state.copyWith(
      id: setNoteData(
        NoteDBParams(
          id: state.id,
          title: state.title,
          text: state.text,
          tags: state.tags,
          color: state.color,
          remindAt: state.remindAt,
          expireAt: state.expireAt,
        ),
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

  void updateRemindAt(DateTime value) {
    state = state.copyWith(remindAt: value);
  }

  void updateExpireAt(DateTime value) {
    state = state.copyWith(expireAt: value);
  }

  void updateTags(List<String> value) {
    state = state.copyWith(tags: value);
  }
}
