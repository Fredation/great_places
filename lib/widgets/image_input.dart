import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

class ImageInput extends StatefulWidget {
  //const ImageInput({Key? key}) : super(key: key);
  final Function? onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _takePhoto() async {
    try {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );

      if (imageFile == null) {
        return;
      }
      setState(() {
        _storedImage = File(imageFile.path);
      });

      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(imageFile.path);

      final savedImage =
          await File(imageFile.path).copy('${appDir.path}/$fileName');
      widget.onSelectImage!(savedImage);
    } catch (error) {
      print('error: /$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 120,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.grey,
          )),
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Chosen',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        const SizedBox(width: 10),
        Expanded(
            child: FlatButton.icon(
          onPressed: _takePhoto,
          icon: const Icon(Icons.camera),
          label: const Text('Take Photo'),
          textColor: Theme.of(context).primaryColor,
        )),
      ],
    );
  }
}
