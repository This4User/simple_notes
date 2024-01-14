import "package:flutter/material.dart";
import "package:simple_notes/constants/note_colors.dart";

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String title;
  final String description;
  final String color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: Ink(
                decoration: BoxDecoration(
                  color: Color(int.parse("0xff$color")),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: noteColors
                              .firstWhere((e) => e.color == color)
                              .contrastingColor,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          description,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            color: noteColors
                                .firstWhere((e) => e.color == color)
                                .contrastingColor,
                          ),
                        ),
                      ),
                    ],
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
