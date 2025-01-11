// ignore_for_file: depend_on_referenced_packages


import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloudinary/cloudinary.dart';

class StorageNodejsRepository {
  final cloudinary = Cloudinary.signedConfig(
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME']!,
    apiKey: dotenv.env['CLOUDINARY_API_KEY']!,
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET']!,
  );
  Future<String> saveImageToStorage({
    required XFile image,
    required String messageId,
  }) async {
    try {
      // Upload ảnh lên Cloudinary
      final response = await cloudinary.upload(
        file: image.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'messages/$messageId',
        publicId: 'image_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Kiểm tra kết quả upload
      if (response.isSuccessful) {
        return response.secureUrl!; 
      } else {
        throw Exception('Không thể tải lên hình ảnh. Lỗi: ${response.error}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải lên hình ảnh: $e');
    }
  }
}
