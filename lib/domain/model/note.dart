import "package:freezed_annotation/freezed_annotation.dart";

part "note.freezed.dart";

part "note.g.dart";

@freezed
class Note with _$Note {
  factory Note({
    required String id,
    required String title,
    required String text,
    required List<String> tags,
    required DateTime? reminder,
    required int? expires,
    required bool isNew,
    @Default("FBF8CC") String color,
  }) = _Note;
}

@freezed
class NoteDto with _$NoteDto {
  const factory NoteDto({
    required String id,
    required String title,
    required String text,
    required List<String> tags,
    required String? reminder,
    required int? expires,
    @Default("FBF8CC") String color,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);
}
