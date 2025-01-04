import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class StorageService {
  static const String _schemesKey = 'sunset_color_schemes';
  static const String _lastUsedSchemeKey = 'last_used_scheme';

  static Map<String, List<Color>>? loadSchemes() {
    final String? stored = html.window.localStorage[_schemesKey];
    if (stored == null) return null;

    try {
      final Map<String, dynamic> decoded = json.decode(stored);
      final Map<String, List<Color>> schemes = {};

      decoded.forEach((key, value) {
        if (value is List) {
          schemes[key] = value
              .map((c) => Color(int.parse(c, radix: 16)))
              .toList();
        }
      });

      return schemes;
    } catch (e) {
      return null;
    }
  }

  static void saveSchemes(Map<String, List<Color>> schemes) {
    final encodedSchemes = schemes.map((key, colors) => MapEntry(
        key,
        colors.map((c) => c.value.toRadixString(16).padLeft(8, '0')).toList()
    ));

    html.window.localStorage[_schemesKey] = json.encode(encodedSchemes);
  }

  static String? getLastUsedScheme() {
    return html.window.localStorage[_lastUsedSchemeKey];
  }

  static void saveLastUsedScheme(String schemeName) {
    html.window.localStorage[_lastUsedSchemeKey] = schemeName;
  }
}