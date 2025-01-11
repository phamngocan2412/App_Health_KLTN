import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'text_firebase_firestore.dart';

class RecognizedTextList extends StatefulWidget {
  const RecognizedTextList({super.key});

  @override
  State<RecognizedTextList> createState() => _RecognizedTextListState();
}

class _RecognizedTextListState extends State<RecognizedTextList> {
  final FirestoreService _firestoreService = FirestoreService();
  DateTime? _selectedDate;

  Future<void> _deleteText(String documentId) async {
    await _firestoreService.deleteRecognizedText(documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 207, 240, 255),
        title: const Text(
          "Danh sách văn bản đã lưu",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pickDate,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedDate = null;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getRecognizedTexts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Không có dữ liệu nào được lưu!")
            );
          }

          final texts = _selectedDate == null
              ? snapshot.data!
              : snapshot.data!.where((textData) {
                  final timestamp =
                      (textData['timestamp'] as Timestamp?)?.toDate();
                  if (timestamp == null) return false;
                  return _isSameDate(timestamp, _selectedDate!);
                }).toList();

          if (texts.isEmpty) {
            return const Center(
              child: Text("Không có dữ liệu cho ngày được chọn!"),
            );
          }

          return ListView.builder(
            itemCount: texts.length,
            itemBuilder: (context, index) {
              final textData = texts[index];
              final text = textData['text'] as String;
              final timestamp = (textData['timestamp'] as Timestamp?)?.toDate();
              final documentId = textData['id'] as String; 

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (timestamp != null)
                                Text(
                                  "Lưu lúc: ${_formatDate(timestamp)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            _confirmDelete(documentId);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _confirmDelete(String documentId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa văn bản này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteText(documentId);
            },
            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}
