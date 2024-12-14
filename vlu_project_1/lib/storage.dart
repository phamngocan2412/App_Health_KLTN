import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  static late GetStorage _storage;

  StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  // Khởi tạo GetStorage
  Future<void> init() async {
    await GetStorage.init();
    _storage = GetStorage();
  }

  // Lưu dữ liệu
  Future<void> saveData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Đọc dữ liệu
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Xoá dữ liệu theo key
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Xoá toàn bộ dữ liệu
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
