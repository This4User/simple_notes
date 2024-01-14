import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:simple_notes/constants/note_colors.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/ui/view_model/note_vm.dart";

@RoutePage()
class NoteView extends HookConsumerWidget {
  const NoteView({
    this.data,
    super.key,
  });

  final Note? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(noteVmProvider);
    final vmNotifier = ref.read(noteVmProvider.notifier);
    final titleController = useTextEditingController();
    final textController = useTextEditingController();

    final color = useMemoized(
      () => Color(int.parse("0xff${vm.color}")),
      [vm.color],
    );

    final contrastingColor = useMemoized(
      () => noteColors.firstWhere((e) => e.color == vm.color).contrastingColor,
      [vm.color],
    );

    useEffect(
      () {
        if (data != null) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            vmNotifier.initNote(data!);
          });
        }

        return vmNotifier.saveNote;
      },
      [],
    );

    useEffect(
      () {
        final selection = titleController.selection;

        titleController.text = vm.title;

        if (titleController.text.isEmpty) return;
        titleController.selection = selection;

        return null;
      },
      [vm.title],
    );

    useEffect(
      () {
        final selection = textController.selection;

        textController.text = vm.text;

        if (textController.text.isEmpty) return;
        textController.selection = selection;

        return null;
      },
      [vm.text],
    );

    return Scaffold(
      backgroundColor: color,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          useSafeArea: true,
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: GridView.count(
                crossAxisCount: 4,
                children: noteColors
                    .map(
                      (e) => InkWell(
                        onTap: () => vmNotifier.updateColor(e.color),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Color(int.parse("0xff${e.color}")),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
        child: const Icon(
          Icons.star,
          size: 40,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                    onChanged: vmNotifier.updateTitle,
                    style: TextStyle(
                      fontSize: 32,
                      color: contrastingColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: color,
                      hintStyle: const TextStyle(fontSize: 32),
                      hintText: "Название",
                      enabledBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      // suffixIcon:
                      //     Icon(Icons.search, color: Colors.black.withOpacity(0.6)),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () => showModalBottomSheet<void>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      useSafeArea: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: GridView.count(
                            crossAxisCount: 4,
                            children: noteColors
                                .map(
                                  (e) => InkWell(
                                    onTap: () =>
                                        vmNotifier.updateColor(e.color),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      color: Color(int.parse("0xff${e.color}")),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    ),
                    child: ColoredBox(
                      color: contrastingColor.withOpacity(0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Container(
                            height: 25,
                            width: 25,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onChanged: vmNotifier.updateText,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 24,
                      color: contrastingColor,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: color,
                      hintStyle: const TextStyle(fontSize: 24),
                      hintText: "Текст заметки",
                      enabledBorder:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
