import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key,required this.onpickimage});
  final void Function(File) onpickimage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _image;
  void _takepicture() async{
    final imagepicker = ImagePicker();
    final image=await imagepicker.pickImage(source: ImageSource.camera,maxWidth: 600);
      setState(() {
        if (image == null) {
          return;
        }
        _image = File(image.path);
        widget.onpickimage(_image!);
      });
    }
  

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        icon: const Icon(Icons.camera),
        onPressed: _takepicture,
        label: const Text('Take a picture'));
    if (_image != null) {
      content = GestureDetector(
        onTap: () {
          _takepicture();
        },
        child: Image.file(
          _image!,
          width: double.infinity,
          fit: BoxFit.cover,
          height: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
