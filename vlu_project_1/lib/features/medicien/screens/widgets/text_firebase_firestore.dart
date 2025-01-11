// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get _currentUser => _auth.currentUser;

  /// Lưu văn bản nhận dạng vào Firestore
  Future<void> saveRecognizedText(String text) async {
    final user = _currentUser;

    if (user == null) {
      throw Exception("Người dùng chưa đăng nhập");
    }

    try {
      await _firestore.collection('recognized_texts').add({
        'text': text,
        'userId': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Lỗi khi lưu văn bản: $e");
      rethrow; 
    }
  }

  /// Lấy toàn bộ dữ liệu của người dùng hiện tại
  Stream<List<Map<String, dynamic>>> getRecognizedTexts() {
    final user = _currentUser;

    if (user == null) {
      throw Exception("Người dùng chưa đăng nhập");
    }

    try {
      return _firestore
          .collection('recognized_texts')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              }).toList());
    } catch (e) {
      print("Lỗi khi lấy dữ liệu từ Firestore: $e");
      if (e.toString().contains('FAILED_PRECONDITION')) {
        throw Exception("Yêu cầu chỉ mục chưa được tạo. Hãy kiểm tra Firestore Console.");
      }
      rethrow;
    }
  }
  Future<void> deleteRecognizedText(String documentId) async {
    await _firestore.collection('recognized_texts').doc(documentId).delete();
  }
}
