class TFirebaseException implements Exception {
  final String code;
  TFirebaseException(this.code);

  String get message {
    switch (code) {
      case 'permission-denied':
        return 'Bạn không có quyền thực hiện hành động này';
      case 'unavailable':
        return 'Máy chủ hiện không khả dụng. Vui lòng thử lại sau.';
      case 'weak-password':
        return 'Mật khẩu được cung cấp quá yếu.';
      case 'email-already-in-use':
        return 'Tài khoản đã tồn tại cho email đó';
      case 'invalid-email':
        return 'Địa chỉ email không đúng định dạng';
      default:
        return 'Đã xảy ra lỗi Firebase. Vui lòng thử lại.';
    }
  }
}

class TFormatException implements Exception {
  const TFormatException();

  String get message => 'Định dạng dữ liệu không hợp lệ.';
}

class TPlatformException implements Exception {
  final String code;

  TPlatformException(this.code);

  String get message {
    switch (code) {
      case 'network_error':
        return 'Lỗi mạng. Vui lòng kiểm tra kết nối internet của bạn.';
      case 'device_not_supported':
        return 'Tính năng này không được hỗ trợ trên thiết bị của bạn.';
      default:
        return 'Đã xảy ra lỗi nền tảng. Vui lòng thử lại.';
    }
  }
}
