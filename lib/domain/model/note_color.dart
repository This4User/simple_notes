import "package:flutter/material.dart";

class NoteColor {
  NoteColor({
    required this.color,
    this.isLight = true,
  });

  final String color;
  final bool isLight;

  Color get contrastingColor => isLight ? Colors.black : Colors.white;
}
