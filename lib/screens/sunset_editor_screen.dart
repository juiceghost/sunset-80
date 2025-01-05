import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/color_picker/color_pickers_panel.dart';
import '../widgets/sunset/sunset_with_blinds.dart';
import '../models/sunset_colors.dart';
import '../services/storage_service.dart';

class SunsetEditorScreen extends StatefulWidget {
  const SunsetEditorScreen({super.key});

  @override
  State<SunsetEditorScreen> createState() => _SunsetEditorScreenState();
}

class _SunsetEditorScreenState extends State<SunsetEditorScreen> {
  late List<Color> controlColors;
  late Map<String, List<Color>> savedSchemes;
  String currentSchemeName = 'Default';
  bool _showBlinds = true;
  double _sunPosition = StorageService.loadSunPosition(); // Load saved position
  double _sunSquish = 1.0;  // Default squish
  double _lineThickness = 0.1;

  @override
  void initState() {
    super.initState();
    _initializeSchemes();
  }

  void _updateSunPosition(double value) {
    setState(() {
      _sunPosition = value;
      StorageService.saveSunPosition(value);
    });
  }

  void _initializeSchemes() {
    savedSchemes = StorageService.loadSchemes() ?? {
      'Default': List.from(SunsetColors.defaultColors),
    };

    String? lastUsedScheme = StorageService.getLastUsedScheme();
    currentSchemeName = savedSchemes.containsKey(lastUsedScheme)
        ? lastUsedScheme!
        : 'Default';
    controlColors = List.from(savedSchemes[currentSchemeName]!);
  }

  void _updateControlColor(int index, Color color) {
    setState(() {
      controlColors[index] = color;
      savedSchemes[currentSchemeName] = List.from(controlColors);
      StorageService.saveSchemes(savedSchemes);
    });
  }

  void _saveNewScheme() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newSchemeName = '';

        return AlertDialog(
          title: const Text('Save Color Scheme'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Scheme Name',
              hintText: 'Enter a name for your color scheme',
            ),
            onChanged: (value) => newSchemeName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newSchemeName.isNotEmpty) {
                  setState(() {
                    savedSchemes[newSchemeName] = List.from(controlColors);
                    currentSchemeName = newSchemeName;
                    StorageService.saveSchemes(savedSchemes);
                    StorageService.saveLastUsedScheme(newSchemeName);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _loadScheme(String schemeName) {
    setState(() {
      currentSchemeName = schemeName;
      controlColors = List.from(savedSchemes[schemeName]!);
      StorageService.saveLastUsedScheme(schemeName);
    });
  }

  void _deleteScheme(String schemeName) {
    if (schemeName == 'Default') return;

    setState(() {
      savedSchemes.remove(schemeName);
      if (currentSchemeName == schemeName) {
        currentSchemeName = 'Default';
        controlColors = List.from(savedSchemes['Default']!);
      }
      StorageService.saveSchemes(savedSchemes);
      StorageService.saveLastUsedScheme(currentSchemeName);
    });
  }

  void _exportSchemes() {
    final jsonStr = json.encode(savedSchemes.map(
            (key, value) => MapEntry(key, value.map((c) => c.value.toRadixString(16).padLeft(8, '0')).toList())
    ));
    Clipboard.setData(ClipboardData(text: jsonStr));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Color schemes copied to clipboard')),
    );
  }

  void _importSchemes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String importData = '';

        return AlertDialog(
          title: const Text('Import Color Schemes'),
          content: TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Paste color schemes data',
              hintText: 'Paste the exported color schemes data here',
            ),
            onChanged: (value) => importData = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                try {
                  final Map<String, dynamic> importedData = json.decode(importData);
                  final Map<String, List<Color>> newSchemes = {};

                  importedData.forEach((key, value) {
                    if (value is List) {
                      newSchemes[key] = value
                          .map((c) => Color(int.parse(c, radix: 16)))
                          .toList();
                    }
                  });

                  if (newSchemes.isNotEmpty) {
                    setState(() {
                      savedSchemes = {'Default': savedSchemes['Default']!};
                      savedSchemes.addAll(newSchemes);
                      StorageService.saveSchemes(savedSchemes);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Color schemes imported successfully')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid import data format')),
                  );
                }
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: DropdownButton<String>(
          value: currentSchemeName,
          dropdownColor: Colors.grey[850],
          style: const TextStyle(color: Colors.white),
          items: savedSchemes.keys.map((String name) {
            return DropdownMenuItem<String>(
              value: name,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name),
                  if (name != 'Default')
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      color: Colors.white,
                      onPressed: () => _deleteScheme(name),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) _loadScheme(newValue);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            color: Colors.white,
            onPressed: _saveNewScheme,
            tooltip: 'Save new scheme',
          ),
          IconButton(
            icon: const Icon(Icons.file_upload),
            color: Colors.white,
            onPressed: _exportSchemes,
            tooltip: 'Export schemes',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            color: Colors.white,
            onPressed: _importSchemes,
            tooltip: 'Import schemes',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;

          if (isWide) {
            return Row(
              children: [
                // Left control panel
                Container(
                  width: 300,
                  color: Colors.grey[900],
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColorPickersPanel(
                        controlColors: controlColors,
                        onColorChanged: _updateControlColor,
                        isHorizontal: false,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Blinds',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: _showBlinds,
                            onChanged: (value) {
                              setState(() {
                                _showBlinds = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const Text(
                        'Sun Position',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.white, size: 16),
                          Expanded(
                            child: Slider(
                              value: _sunPosition,
                              onChanged: _updateSunPosition,
                              min: -0.2, // Allow movement past bottom
                              max: 1.2,  // Allow movement past top
                            ),
                          ),
                          const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                        ],
                      ),
                      const Text(
                        'Line Thickness',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.remove, color: Colors.white, size: 16),
                          Expanded(
                            child: Slider(
                              value: _lineThickness,
                              min: 0.02,
                              max: 0.2,
                              onChanged: (value) {
                                setState(() {
                                  _lineThickness = value;
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.add, color: Colors.white, size: 16),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sun Squish',
                        style: TextStyle(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.compress, color: Colors.white, size: 16),
                          Expanded(
                            child: Slider(
                              value: _sunSquish,
                              min: 1.0,
                              max: 1.5,
                              onChanged: (value) {
                                setState(() {
                                  _sunSquish = value;
                                });
                              },
                            ),
                          ),
                          const Icon(Icons.expand, color: Colors.white, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
                // Main display area
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,  // Fixed width based on image
                      height: 600, // Fixed height based on image
                      child: SunsetWithBlinds(
                        controlColors: controlColors,
                        showBlinds: _showBlinds,
                        sunPosition: _sunPosition,
                        sunSquish: _sunSquish,
                        lineThickness: _lineThickness,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Container(
                  color: Colors.grey[900],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: ColorPickersPanel(
                          controlColors: controlColors,
                          onColorChanged: _updateControlColor,
                          isHorizontal: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Blinds',
                            style: TextStyle(color: Colors.white),
                          ),
                          Switch(
                            value: _showBlinds,
                            onChanged: (value) {
                              setState(() {
                                _showBlinds = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.85,
                      heightFactor: 0.7,
                      child: AspectRatio(
                        aspectRatio: 2/3,
                        child: SunsetWithBlinds(
                          controlColors: controlColors,
                          showBlinds: _showBlinds,
                          sunPosition: _sunPosition,
                          lineThickness: _lineThickness,
                          sunSquish: _sunSquish,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}