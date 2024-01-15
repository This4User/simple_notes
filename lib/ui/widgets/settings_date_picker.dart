import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:simple_notes/ui/widgets/note_settings.dart";

class SettingsDatePicker extends StatelessWidget {
  const SettingsDatePicker({
    required this.title,
    required this.onUpdate,
    super.key,
  });

  final String title;
  final void Function(DateTime date) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const BoxDecoration(
        color: Color(0xffD2D6EF),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onTap: () => showCupertinoModalBottomSheet(
              context: context,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                use24hFormat: true,
                showDayOfWeek: true,
                onDateTimeChanged: onUpdate,
              ),
            ),
            child: Ink(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xff104547),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
