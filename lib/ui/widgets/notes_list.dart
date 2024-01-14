import "package:flutter/cupertino.dart";
import "package:flutter_staggered_animations/flutter_staggered_animations.dart";
import "package:simple_notes/domain/model/note.dart";
import "package:simple_notes/ui/widgets/note_list_item.dart";

class NotesList extends StatelessWidget {
  const NotesList({
    required this.items,
    required this.onTap,
    super.key,
  });

  final List<Note> items;
  final void Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final note = items[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50,
                child: SlideAnimation(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: NoteListItem(
                      title: note.title,
                      description: note.text,
                      color: note.color,
                      onTap: () => onTap(note.id),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    // return SingleChildScrollView(
    //   child: Padding(
    //     padding: const EdgeInsets.all(10),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: items
    //           .map(
    //             (note) => Padding(
    //               padding: const EdgeInsets.only(bottom: 5),
    //               child: NoteListItem(
    //                 title: note.title,
    //                 description: note.text,
    //                 color: note.color,
    //                 onTap: () => onTap(note.id),
    //               ),
    //             ),
    //           )
    //           .toList(),
    //     ),
    //   ),
    // );
  }
}
