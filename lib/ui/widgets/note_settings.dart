import "package:flutter/cupertino.dart";
import "package:simple_notes/ui/widgets/settings_date_picker.dart";

void showCupertinoModalBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}

class NoteSettings extends StatelessWidget {
  const NoteSettings({
    required this.tags,
    required this.reminder,
    required this.onUpdateReminder,
    required this.expiration,
    required this.onUpdateExpiration,
    super.key,
  });

  final List<String> tags;

  final String? reminder;
  final void Function(DateTime date) onUpdateReminder;

  final String? expiration;
  final void Function(DateTime date) onUpdateExpiration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: SettingsDatePicker(
            title: reminder ?? "Напоминание не установлено",
            onUpdate: onUpdateReminder,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SettingsDatePicker(
            title: expiration ?? "Срок жизни не установлен",
            onUpdate: onUpdateExpiration,
          ),
        ),
      ],
    );
  }
}
