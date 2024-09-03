import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickImage});
  final void Function(File pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  bool _isLoading = false;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await showDialog(
      context: context,
      builder: (ctx) => _buildImageSourceDialog(ctx, picker),
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });

      widget.onPickImage(_pickedImageFile!);
    } catch (error) {
      // Handle any errors here, such as showing a dialog or snackbar
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  AlertDialog _buildImageSourceDialog(
      BuildContext context, ImagePicker picker) {
    return AlertDialog(
      title: const Text('Choose Image Source'),
      actions: [
        TextButton(
          child: const Text('Gallery'),
          onPressed: () async {
            Navigator.of(context).pop(await picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
              maxWidth: 150,
            ));
          },
        ),
        TextButton(
          child: const Text('Camera'),
          onPressed: () async {
            Navigator.of(context).pop(await picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 50,
              maxWidth: 150,
            ));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading
            ? const CircularProgressIndicator()
            : CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                foregroundImage: _pickedImageFile != null
                    ? FileImage(_pickedImageFile!)
                    : null,
              ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: Text(
            "Add Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
