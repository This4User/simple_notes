import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
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

class NoteSettings extends HookWidget {
  const NoteSettings({
    required this.color,
    required this.contrastingColor,
    required this.tags,
    required this.reminder,
    required this.onUpdateReminder,
    required this.expiration,
    required this.onUpdateExpiration,
    required this.onUpdateTags,
    required this.onDelete,
    super.key,
  });

  final Color color;
  final Color contrastingColor;
  final List<String> tags;

  final String? reminder;
  final void Function(DateTime date) onUpdateReminder;

  final int? expiration;
  final void Function(int value) onUpdateExpiration;

  final void Function(List<String> value) onUpdateTags;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final reminderDate = useState<String?>(reminder);
    final isTagFieldOpened = useState<bool>(false);
    final tagTextController = useTextEditingController();
    final expirationTextController =
        useTextEditingController(text: expiration?.toString() ?? "");

    final isFirstRender = useState<bool>(true);
    final settingsTags = useState<List<String>>(tags);

    useEffect(() {
      if (!isFirstRender.value) {
        Future(() {
          onUpdateTags(settingsTags.value);
        });
      }

      isFirstRender.value = false;
      return null;
    }, [
      settingsTags.value,
    ]);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (settingsTags.value.isNotEmpty)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 4,
                  children: settingsTags.value
                      .asMap()
                      .entries
                      .map(
                        (e) => Ink(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: color,
                          ),
                          child: InkWell(
                            onTap: () => settingsTags.value = [
                              ...settingsTags.value,
                            ]..removeAt(e.key),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: Text(
                                  e.value,
                                  style: TextStyle(
                                    color: contrastingColor,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settingsTags.value.length < 5)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isTagFieldOpened.value)
                          Ink(
                            decoration: const BoxDecoration(
                              color: Color(0xffD2D6EF),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: TextField(
                                      controller: tagTextController,
                                      onTapOutside: (_) {
                                        if (tagTextController.text.isEmpty) {
                                          isTagFieldOpened.value = false;
                                        }
                                      },
                                      maxLength: 20,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onTap: () {
                                    final newTag = tagTextController.text;

                                    isTagFieldOpened.value = false;
                                    if (newTag.isNotEmpty) {
                                      settingsTags.value = [
                                        ...settingsTags.value,
                                        newTag,
                                      ];
                                    }
                                    tagTextController.clear();
                                  },
                                  child: Ink(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff104547),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Color(0xffA4B0F5),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (settingsTags.value.isEmpty &&
                            !isTagFieldOpened.value)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Добавить тег",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                onTap: () => isTagFieldOpened.value = true,
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SettingsDatePicker(
              title: reminderDate.value ?? "Установить напоминание -->",
              onUpdate: (DateTime value) {
                reminderDate.value = value.toString();
                onUpdateReminder(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Ink(
              decoration: const BoxDecoration(
                color: Color(0xffD2D6EF),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextField(
                  controller: expirationTextController,
                  onChanged: (String value) =>
                      onUpdateExpiration(int.parse(value)),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Установить срок жизни",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.7),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Удалить",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
