// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Thêm vào package lottie
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
  bool _isFirstLaunch = true; 
  bool _isMessageSent = false; 
  bool _isLoading = false; 

  @override
  void initState() {
    super.initState();
    _loadFirstLaunchStatus();
    _messageController = TextEditingController();
  }

  Future<void> _loadFirstLaunchStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFirstLaunch = prefs.getBool('isFirstLaunch');
    if (isFirstLaunch == null) {
      setState(() {
        _isFirstLaunch = true; 
      });
      _setFirstLaunchStatus(false); 
    } else {
      setState(() {
        _isFirstLaunch = false;
      });
    }
  }
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
          child: Stack(
            children: [
              Column(
                children: [
                  // Message List
                  Expanded(
                    child: MessagesList(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                  if (_isFirstLaunch && !_isMessageSent)
                    SuggestionsWidget(
                      onSuggestionSelected: _handleSuggestion,
                      isFirstLaunch: _isFirstLaunch,
                    ),
                  const SizedBox(height: 40),
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
                                sendMessage(); 
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
              if (_isLoading)
                Positioned(
                  bottom: 80,  
                  left: 15,
                  child: Lottie.asset(
                    'assets/images/chat_loading.json',
                    width: 50,
                    height: 50,
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
    ) ?? false;
  }

  Future sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;
    
    setState(() {
      _isMessageSent = true;
      _isFirstLaunch = false; 
      _isLoading = true;
    });

    _messageController.clear(); 

    await ref.read(chatProvider).sendTextMessage(
      apiKey: apiKey,
      textPrompt: message,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}