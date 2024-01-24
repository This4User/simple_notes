import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:simple_notes/constants/note_colors.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/ui/view_model/note_vm.dart";
import "package:simple_notes/ui/widgets/note_settings.dart";

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

        return vmNotifier.syncNote;
      },
      [],
    );

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          vmNotifier.saveNote();
        });

        return null;
      },
      [vm],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
                    child: Ink(
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
                          child: NoteSettings(
                            color: color,
                            contrastingColor: contrastingColor,
                            tags: vm.tags,
                            reminder: vm.remindAt?.toString(),
                            expiration: vm.expireAt?.toString(),
                            onUpdateReminder: vmNotifier.updateRemindAt,
                            onUpdateExpiration: vmNotifier.updateExpireAt,
                            onUpdateTags: vmNotifier.updateTags,
                            onDelete: vmNotifier.delete,
                          ),
                        );
                      },
                    ),
                    child: Ink(
                      color: contrastingColor.withOpacity(0.7),
                      child: Icon(
                        Icons.settings,
                        size: 41,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Row(
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
                          height: 1.25,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: color,
                          hintStyle: const TextStyle(fontSize: 24),
                          hintText: "Текст заметки",
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
