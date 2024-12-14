// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vlu_project_1/permission_manager.dart';

import '../../../../shared/image_preview.dart';
import 'firebase_firestore.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({super.key});

  @override
  State<TextRecognitionWidget> createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  late TextRecognizer textRecognizer;
  late ImagePicker imagePicker;
  final FirestoreService _firestoreService = FirestoreService();

  String? pickedImagePath;
  String recognizedText = "";

  bool isRecognizing = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkCameraPermissions();
    });
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    imagePicker = ImagePicker();
  }

  Future<void> _checkCameraPermissions() async {
    if (!await Permission.storage.isGranted) {
      if (mounted) {
        await PermissionManager.checkAndRequestCameraPermission(context);
      }
      // Kiểm tra lại sau khi yêu cầu cấp quyền
      if (!await Permission.storage.isGranted) {
        print("Người dùng từ chối quyền lưu trữ.");
      }
    }
  }


  Future<void> _saveTextToFirestore() async {
    if (recognizedText.isNotEmpty) {
      try {
        await _firestoreService.saveRecognizedText(recognizedText);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Văn bản đã được lưu vào Firestore')),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu văn bản: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có văn bản để lưu')),
      );
    }
  }

  void _pickImageAndProcess({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImagePath = pickedImage.path;
      isRecognizing = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(pickedImage.path);
      final RecognizedText recognisedText =
          await textRecognizer.processImage(inputImage);

      recognizedText = "";

      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          recognizedText += "${line.text}\n";
        }
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recognizing text: $e'),
        ),
      );
    } finally {
      setState(() {
        isRecognizing = false;
      });
    }
  }

  void _chooseImageSourceModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Chọn từ thư viện'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageAndProcess(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Chụp một bức ảnh'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageAndProcess(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _copyTextToClipboard() async {
    if (recognizedText.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: recognizedText));
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Văn bản đã được sao chép vào clipboard'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ImagePreview(imagePath: pickedImagePath),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // rounded corners
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), // padding
          ),
          onPressed: isRecognizing ? null : _chooseImageSourceModal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Chọn một hình ảnh'),
              if (isRecognizing) ...[
                const SizedBox(width: 20),
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Chuyển đổi sang văn bản",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(
                  Icons.copy,
                  size: 20,
                ),
                onPressed: _copyTextToClipboard,
              ),
              IconButton(
                icon: const Icon(
                  Icons.save,
                  size: 25,
                ),
                onPressed: _saveTextToFirestore,
              ),
            ],
          ),
        ),
        if (!isRecognizing) ...[
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Flexible(
                      child: SelectableText(
                        recognizedText.isEmpty
                            ? "Không nhận dạng được văn bản"
                            : recognizedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ],
    );
  }
}
