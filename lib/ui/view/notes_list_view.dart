import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:simple_notes/ui/router/config.dart";
import "package:simple_notes/ui/view_model/notes_vm.dart";
import "package:simple_notes/ui/widgets/notes_list.dart";

@RoutePage()
class NotesListView extends HookConsumerWidget {
  const NotesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(notesVmProvider);
    final vmNotifier = ref.read(notesVmProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xff49494A),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF3F5F9),
        onPressed: () => context.router.push(
          NoteRoute(),
        ),
        child: const Icon(
          Icons.add_circle_outline,
          size: 40,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xff49494A),
        title: const Row(
          children: [
            Text(
              "Привет :)",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xffF3F5F9),
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: vm.items.isNotEmpty
            ? NotesList(
                items: vm.items,
                onTap: (String id) {
                  context.router.push(
                    NoteRoute(
                      data: vmNotifier.getById(id),
                    ),
                  );
                },
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Пока что заметок нет,\n создай новую :)",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () => context.router.push(
                        NoteRoute(),
                      ),
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2,
                              offset: Offset(0, 2),
                            ),
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Создать новую заметку",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
