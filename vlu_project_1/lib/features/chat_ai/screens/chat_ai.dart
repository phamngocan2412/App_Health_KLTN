import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/widgets/loaders.dart';
import 'send_image_screen.dart';
import 'widgets/messages_list.dart';
import 'widgets/suggestions_widget.dart';

class ChatAi extends ConsumerStatefulWidget {
  const ChatAi({super.key});

  @override
  ConsumerState<ChatAi> createState() => _ChatAiState();
}

class _ChatAiState extends ConsumerState<ChatAi> {
  late final TextEditingController _messageController;
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  bool _isFirstLaunch = true; // Khi ứng dụng mới được mở, hiển thị SuggestionsWidget
  bool _isMessageSent = false; // Trạng thái để kiểm tra liệu tin nhắn đã được gửi hay chưa

  @override
  void initState() {
    super.initState();
    _loadFirstLaunchStatus();
    _messageController = TextEditingController();
  }

  // Tải trạng thái _isFirstLaunch từ SharedPreferences
  Future<void> _loadFirstLaunchStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    });
  }

  // Lưu trạng thái _isFirstLaunch vào SharedPreferences
  Future<void> _setFirstLaunchStatus(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', value);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSuggestion(String suggestion) {
    setState(() {
      _isFirstLaunch = false; 
      _isMessageSent = false;
    });
    _messageController.text = suggestion;
    _setFirstLaunchStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('assets/images/logo.png', height: 30),
          elevation: 2,
          shadowColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await _showConfirmDeleteDialog(context);
                if (confirm) {
                  await ref.read(chatProvider).clearChatHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lịch sử đoạn chat đã được xóa")),
                  );
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              // Message List
              Expanded(
                child: MessagesList(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                ),
              ),
              // Hiển thị SuggestionsWidget chỉ khi chưa gửi tin nhắn
              if (_isFirstLaunch && !_isMessageSent)
                SuggestionsWidget(
                  onSuggestionSelected: _handleSuggestion,
                  isFirstLaunch: _isFirstLaunch,
                ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Nhập câu hỏi của bạn ...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Icon to open SendImageScreen
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SendImageScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.image,
                          color: Color.fromARGB(255, 0, 140, 255),
                        ),
                      ),
                      // Send button
                      IconButton(
                        onPressed: () {
                          if (_messageController.text.trim().isNotEmpty) {
                            sendMessage(); // Gọi hàm sendMessage nếu nội dung không trống
                          } else {
                            Loaders.warningSnackBar(
                              title: "Tin nhắn không được để trống.",
                              message: "Vui lòng nhập nội dung.",
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Xác nhận"),
            content: const Text("Bạn có chắc chắn muốn xóa toàn bộ lịch sử đoạn chat?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Hủy"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Xóa", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    setState(() {
      _isMessageSent = true;
      _isFirstLaunch = false; 
    });

    _messageController.clear(); 

    await ref.read(chatProvider).sendTextMessage(
      apiKey: apiKey,
      textPrompt: message,
    );
  }
}

// colloctien snapshot 