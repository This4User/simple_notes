import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/ui/view/note_view.dart";
import "package:simple_notes/ui/view/notes_list_view.dart";

part "config.gr.dart";

@AutoRouterConfig(replaceInRouteName: "View,Route")
class AppRouter extends _$AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: NotesListRoute.page,
        ),
        AutoRoute(
          page: NoteRoute.page,
        ),
      ];
}
