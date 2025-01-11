// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../core/providers/providers.dart';
import '../../../core/utils/image_picker.dart';

class SendImageScreen extends ConsumerStatefulWidget {
  const SendImageScreen({super.key});

  @override
  ConsumerState<SendImageScreen> createState() => _SendImageScreenState();
}

class _SendImageScreenState extends ConsumerState<SendImageScreen> {
  XFile? image;
  late final TextEditingController _promptController;
  bool isLoading = false;
  final apiKey = dotenv.env['API_KEY'] ?? '';

  @override
  void initState() {
    _pickImage();
    _promptController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final pickedImage = await pickImage();
    if (pickedImage == null) {
      return;
    }
    setState(() => image = pickedImage);
  }

  void _removeImage() async {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Image Prompt'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            Container(
              height: 400,
              color: Colors.grey[200],
              child: image == null
                  ? const Center(
                      child: Text(
                        'No Image Selected',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
            ),
            // Pick and Remove image buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                        padding: const EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: const Text('Pick Image', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                        backgroundColor: Colors.red[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: _removeImage,
                      child: const Text('Remove Image', style: TextStyle(color: Colors.white)),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),
            // Text Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  hintText: 'Write something about the image...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            const SizedBox(height: 50),
            // Send Message Button
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: isLoading
                  ? Center(
                      child: Lottie.asset(
                        'assets/images/chat_loading.json',
                        width: 100,
                        height: 100,
                      ),
                    )
                  : SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                        style:  ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (image == null) return;
                          setState(() => isLoading = true);
                          await ref.read(chatProvider).sendMessage(
                                apiKey: apiKey,
                                image: image,
                                promptText: _promptController.text.trim(),
                              );
                          Navigator.of(context).pop();
                          setState(() => isLoading = false);
                        },
                        child: const Text('Send Message', style: TextStyle(color: Colors.white)),
                      ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}