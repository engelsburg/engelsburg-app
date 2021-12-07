import 'package:flutter/material.dart';

class ColorGrid extends StatelessWidget {
  final void Function(Color color) onColorSelected;
  final Color? currentColor;

  ColorGrid({Key? key, required this.onColorSelected, this.currentColor})
      : super(key: key);

  final colors = [];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 16.0,
      mainAxisSpacing: 16.0,
      shrinkWrap: true,
      children: [...Colors.primaries, ...Colors.accents]
          .map(
            (color) => RawMaterialButton(
              onPressed: () => onColorSelected(color),
              child: currentColor?.value == color.value
                  ? const Icon(Icons.check)
                  : null,
              fillColor: color,
              shape: const CircleBorder(),
            ),
          )
          .toList(),
    );
  }
}
