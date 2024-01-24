import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:simple_notes/domain/collection/note.dart";
import "package:simple_notes/domain/database/instance.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/domain/notifications/instance.dart";
import "package:simple_notes/domain/repository/notes.dart";

part "notes_vm.freezed.dart";

part "notes_vm.g.dart";

@freezed
class NotesModel with _$NotesModel {
  const factory NotesModel({
    @Default(false) bool isInitialized,
    @Default(0) int totalCount,
    @Default([]) List<Note> items,
  }) = _NotesModel;
}

@riverpod
class NotesVm extends _$NotesVm {
  @override
  NotesModel build() {
    return const NotesModel();
  }

  Future<void> init() async {
    if (!state.isInitialized) _initListenLocalChanges();

    final notes = (await getAllNotes()).reversed.toList();

    await _setNotifications(notes);

    state = state.copyWith(
      items: notes,
    );
  }

  void _initListenLocalChanges() {
    IsarInstance.get.notes.watchLazy().listen((_) => init());
    state = state.copyWith(
      isInitialized: true,
    );
  }

  Future<void> _setNotifications(List<Note> notes) async {
    await NotificationsInstance.get.cancelAll();

    for (final note in notes) {
      if (note.reminder != null && note.reminder!.isAfter(DateTime.now())) {
        await NotificationsInstance.scheduleNotification(
          body: note.title,
          dateString: note.reminder!.toIso8601String(),
        );
      }
    }
  }

  Note getById(String id) {
    return state.items.firstWhere((note) => note.id == id);
  }
}
