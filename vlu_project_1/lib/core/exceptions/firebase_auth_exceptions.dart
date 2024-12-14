// Custom exception class to handle various Firebase authentication-related errors.
class TFirebaseAuthException implements Exception {
  // The error code associated with the Firebase authentication exception.
  final String code;

  // Constructor that takes an error code
  TFirebaseAuthException(this.code);

  // Get the corresponding error message based on the error code.
  String get message {
    switch (code) {
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng một email khác.';
      case 'invalid-email':
        return 'Địa chỉ email được cung cấp không hợp lệ. Vui lòng nhập một email hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn một mật khẩu mạnh hơn.';
      case 'user-disabled':
        return 'Tài khoản người dùng này đã bị vô hiệu hóa. Vui lòng liên hệ với bộ phận hỗ trợ để được trợ giúp.';
      case 'user-not-found':
        return 'Thông tin đăng nhập không hợp lệ, không tìm thấy người dùng.';
      case 'wrong-password':
        return 'Mật khẩu không đúng. Vui lòng kiểm tra mật khẩu của bạn và thử lại.';
      case 'invalid-verification-code':
        return 'Mã xác minh không hợp lệ. Vui lòng nhập một mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.';
      case 'quota-exceeded':
        return 'Đã vượt quá hạn. Vui lòng thử lại sau.';
      case 'email-already-exists':
        return 'Địa chỉ email đã tồn tại. Vui lòng sử dụng một email khác.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với một nhà cung cấp khác.';
      case 'requires-recent-login':
        return 'Hoạt động này nhạy cảm và yêu cầu xác thực gần đây. Vui lòng đăng nhập lại.';
      case 'credential-already-in-use':
        return 'Thông tin xác thực này đã được liên kết với một tài khoản người dùng khác.';
      case 'user-mismatch':
        return 'Thông tin đăng nhập được cung cấp không khớp với người dùng đã đăng nhập trước đó.';
      case 'account-exists-with-different-credential':
        return 'Đã tồn tại một tài khoản có cùng email nhưng thông tin đăng nhập khác.';
      case 'expired-action-code':
        return 'Mã xác minh đã hết hạn. Vui lòng yêu cầu mã xác minh mới.';
      case 'operation-not-allowed':
        return 'Không được phép thực hiện thao tác này. Liên hệ với bộ phận hỗ trợ để được trợ giúp.';
      case 'invalid-action-code':
        return 'Mã xác minh không hợp lệ. Vui lòng kiểm tra mã xác minh và thử lại.';
      case 'user-token-expired':
        return 'Mã thông báo của người dùng đã hết hạn và cần phải xác thực. Vui lòng đăng nhập lại.';
      case 'invalid-credential':
        return 'Thông tin xác thực được cung cấp không đúng.';
      case 'user-token-revoked':
        return 'Mã thông báo của người dùng đã bị thu hồi. Vui lòng đăng nhập lại.';
      case 'invalid-message-payload':
        return 'Tải tin nhắn xác minh mẫu email không hợp lệ.';
      case 'invalid-sender':
        return 'Người gửi mẫu email không hợp lệ. Vui lòng xác minh email của người gửi.';
      case 'invalid-recipient-email':
        return 'Người nhận mẫu email không hợp lệ. Vui lòng xác minh email người nhận.';
      case 'operation-not-supported-in-this-environment':
        return 'Thao tác này không được hỗ trợ trong môi trường mà ứng dụng của bạn đang chạy.';
      case 'cancelled-popup-request':
        return 'Tất cả các cửa sổ bật lên sẽ không thành công';
      default:
        return 'Đã xảy ra lỗi không xác định. Vui lòng thử lại sau.';
    }
  }
}
