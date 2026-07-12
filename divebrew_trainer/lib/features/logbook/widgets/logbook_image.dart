import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LogbookImage extends StatelessWidget {
  final String path;
  final BoxFit fit;

  const LogbookImage({super.key, required this.path, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('base64:')) {
      final base64Str = path.substring(7);
      return Image.memory(
        base64Decode(base64Str),
        fit: fit,
      );
    } else {
      if (kIsWeb) {
        return Image.network(path, fit: fit);
      } else {
        return Image.file(File(path), fit: fit);
      }
    }
  }
}
