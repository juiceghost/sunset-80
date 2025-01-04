import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

class ColorPickerButton extends StatelessWidget {
  final Color color;
  final Function(Color) onColorChanged;
  final String label;

  const ColorPickerButton({
    super.key,
    required this.color,
    required this.onColorChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showColorPicker(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color pickerColor = color;
    TextEditingController redController = TextEditingController(text: color.red.toString());
    TextEditingController greenController = TextEditingController(text: color.green.toString());
    TextEditingController blueController = TextEditingController(text: color.blue.toString());

    void updateColorFromRGB() {
      try {
        final r = int.parse(redController.text).clamp(0, 255);
        final g = int.parse(greenController.text).clamp(0, 255);
        final b = int.parse(blueController.text).clamp(0, 255);
        pickerColor = Color.fromARGB(255, r, g, b);
        onColorChanged(pickerColor);
      } catch (e) {
        // Handle invalid input
      }
    }

    void updateControllersFromColor(Color color) {
      redController.text = color.red.toString();
      greenController.text = color.green.toString();
      blueController.text = color.blue.toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(label),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    pickerColor = color;
                    updateControllersFromColor(color);
                    onColorChanged(color);
                  },
                  enableAlpha: false,
                  labelTypes: const [],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildColorInput('R', redController, updateColorFromRGB),
                    _buildColorInput('G', greenController, updateColorFromRGB),
                    _buildColorInput('B', blueController, updateColorFromRGB),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorInput(String label, TextEditingController controller, VoidCallback onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            Text(label),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _MaxValueTextInputFormatter(255),
              ],
              onChanged: (_) => onChanged(),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaxValueTextInputFormatter extends TextInputFormatter {
  final int maxValue;

  _MaxValueTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }
    if (value > maxValue) {
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }
    return newValue;
  }
}