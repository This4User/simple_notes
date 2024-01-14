import "package:freezed_annotation/freezed_annotation.dart";

part "note.freezed.dart";

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String text,
    @Default("FBF8CC") String color,
  }) = _Note;
}
