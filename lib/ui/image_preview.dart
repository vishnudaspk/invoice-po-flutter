import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List fileBytes;

  const ImagePreview({super.key, required this.fileBytes});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      fileBytes, fit: BoxFit.cover,
      // height: 400, width: 500
    );
  }
}
