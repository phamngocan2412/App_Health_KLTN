// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class StorageNodejsRepository {
  // Địa chỉ API của server backend của bạn
  final String serverUrl = 'http://192.168.1.9:8000/upload'; 

  Future<String> saveImageToStorage({
    required XFile image,
    required String messageId,
  }) async {
    try {
      // Đọc hình ảnh và chuyển thành dữ liệu bytes
      var imageBytes = await image.readAsBytes();

      // Gửi yêu cầu POST với hình ảnh
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl))
        ..files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: image.name));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Lấy đường dẫn hình ảnh từ server
        var responseBody = await response.stream.bytesToString();
        var responseJson = json.decode(responseBody);
        return responseJson['imageUrl'];  // Trả về đường dẫn hình ảnh
      } else {
        throw Exception('Không thể tải lên hình ảnh');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải lên hình ảnh: $e');
    }
  }
}



// @immutable
// class StorageRepository {
//   final _storage = FirebaseStorage.instance;

//   Future<String> saveImageToStorage({
//     required XFile image,
//     required String messageId,
//   }) async {
//     try {
//       Reference ref = _storage.ref('images').child(messageId);
//       TaskSnapshot snapshot = await ref.putFile(File(image.path));
//       String downloadUrl = await snapshot.ref.getDownloadURL();

//       return downloadUrl;
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
