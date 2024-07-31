import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

class ImagePickerHandler {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    if (kIsWeb) {
      return _pickImageWeb();
    } else {
      return _pickImageMobile();
    }
  }

  Future<File?> _pickImageMobile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> _pickImageWeb() async {
    final completer = Completer<File?>();
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files[0]);
        reader.onLoadEnd.listen((event) {
          completer.complete(File(reader.result as String));
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }
}

class ImageDisplay extends StatelessWidget {
  final File? image;

  const ImageDisplay({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return image != null ? Image.network(image!.path) : Text('No image selected.');
    } else {
      return image != null ? Image.file(image!) : Text('No image selected.');
    }
  }
}
