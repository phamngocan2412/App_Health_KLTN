// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vlu_project_1/permission_manager.dart';

import '../../../../shared/image_preview.dart';
import 'text_firebase_firestore.dart';

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

  // Thêm TextEditingController để quản lý văn bản chỉnh sửa
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> _checkCameraPermissions() async {
    if (!await Permission.storage.isGranted) {
      if (mounted) {
        await PermissionManager.checkAndRequestCameraPermission(context);
      }
      if (!await Permission.storage.isGranted) {
        print("Người dùng từ chối quyền lưu trữ.");
      }
    }
  }

  // Lưu văn bản vào Firestore
  Future<void> _saveTextToFirestore() async {
    if (_textEditingController.text.isNotEmpty) {
      try {
        await _firestoreService.saveRecognizedText(_textEditingController.text);
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

      _textEditingController.text = recognizedText;
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi nhận dạng văn bản: $e'),
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
                  _checkCameraPermissions();
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
    if (_textEditingController.text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: _textEditingController.text));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhận dạng văn bản từ hình ảnh"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ImagePreview(imagePath: pickedImagePath),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _textEditingController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none, 
                  enabledBorder: InputBorder.none, 
                  focusedBorder: InputBorder.none,
                  hintText: "Văn bản nhận dạng sẽ hiển thị ở đây",
                ),
                onChanged: (value) {
                  recognizedText = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}