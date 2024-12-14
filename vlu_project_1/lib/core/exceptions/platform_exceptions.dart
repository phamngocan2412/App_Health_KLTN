// Exception class to handle various platform-related errors.
class TPlatformException implements Exception {
  final String code;

  TPlatformException(this.code);

  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ. Vui lòng kiểm tra thông tin của bạn.';
      case 'too-many-requests':
        return 'Đã có quá nhiều yêu cầu. Vui lòng thử lại sau.';
      case 'invalid-argument':
        return 'Tham số không hợp lệ được cung cấp cho phương thức xác thực.';
      case 'invalid-password':
        return 'Mật bạn không chính xác. Vui lòng thử lại.';
      case 'invalid-phone-number':
        return 'Số điện thoại được cung cấp không hợp lệ.';
      case 'operation-not-allowed':
        return 'Nhà cung cấp đăng nhập đã bị vô hiệu hóa cho dự án Firebase của bạn';
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'Đã có quá nhiều yêu cầu. Vui bạn thử được thao tác.';
      case 'user-disabled':
        return 'Tài khoản người dùng không bị vô hiệu hóa. Vui không thử được thao tác.';
      case 'sign-in-failed':
        return 'Đăng nhập không hợp lệ. Vui lònh thử lại.';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng. Vui lòng thử lại.';
      case 'internal-error':
        return 'Lỗi nội bộ. vui lòng thử lại sau.';
      case 'invalid-verification-code':
        return 'Mã xác minh không hợp lệ. Vui lòng nhập một mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.';
      default:
        return '';
    }
  }
}
