import "package:simple_notes/api/instance.dart";
import "package:simple_notes/domain/model/note.dart";

Future<NoteDto?> sendCreateNote(NoteDto data) async {
  final response = await dio.post<Map<String, dynamic>>(
    "/create",
    data: data.toJson(),
  );

  if (response.data == null) return null;

  return NoteDto.fromJson(response.data!);
}

Future<NoteDto?> sendUpdateNote(NoteDto data) async {
  try {
    final response = await dio.put<Map<String, dynamic>>(
      "/update",
      data: data.toJson(),
    );

    if (response.data == null) return null;

    return NoteDto.fromJson(response.data!);
  } catch (_) {
    return null;
  }
}

Future<void> sendDeleteNote(String? id) async {
  if (id == null) return;

  try {
    await dio.delete<void>(
      "/delete",
      data: {
        "id": id,
      },
    );
  } catch (_) {}
}

Future<List<NoteDto>> sendGetAllNotes() async {
  final response = await dio.get<List<dynamic>>("/all");

  if (response.data == null) return [];

  return response.data!
      .map((data) => NoteDto.fromJson(data as Map<String, dynamic>))
      .toList();
}
