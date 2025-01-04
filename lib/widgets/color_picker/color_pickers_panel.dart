import 'package:flutter/material.dart';
import 'color_picker_button.dart';

class ColorPickersPanel extends StatelessWidget {
  final List<Color> controlColors;
  final Function(int, Color) onColorChanged;
  final bool isHorizontal;

  const ColorPickersPanel({
    super.key,
    required this.controlColors,
    required this.onColorChanged,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget colorPickers = Padding(
      padding: const EdgeInsets.all(8.0), // Reduced padding
      child: isHorizontal
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Changed to start
          children: _buildColorPickers(),
        ),
      )
          : Wrap( // Changed from Column to Wrap
        spacing: 8,
        runSpacing: 8,
        children: _buildColorPickers(),
      ),
    );

    return Container(
      color: Colors.grey[900],
      child: colorPickers,
    );
  }

  List<Widget> _buildColorPickers() {
    return List.generate(
      controlColors.length,
          (index) => SizedBox(
        width: 70, // Fixed width for each picker
        child: ColorPickerButton(
          color: controlColors[index],
          onColorChanged: (color) => onColorChanged(index, color),
          label: '${index + 1}',
        ),
      ),
    );
  }
}