// Custom exception class to handle various Firebase authentication-related errors.
class TFirebaseException implements Exception {
  // The error code associated with the exception.
  final String code;

  // Constructor that takes in the error code.
  TFirebaseException(this.code);

  String getMessage(String code) {
    switch (code) {
      case 'unknown':
        return 'Đã xảy ra một lỗi Firebase không xác định. Vui lòng thử lại.';
      case 'invalid-custom-token':
        return 'Định dạng token tùy chỉnh không chính xác. Vui lòng kiểm tra token tùy chỉnh của bạn.';
      case 'custom-token-mismatch':
        return 'Token tùy chỉnh tương ứng với một đối tượng khác.';
      case 'user-disabled':
        return 'Tài khoản người dùng đã bị vô hiệu hóa.';
      case 'user-not-found':
        return 'Không tìm thấy người dùng sử dụng email hoặc UID.';
      case 'invalid-email':
        return 'Địa chỉ email được cung cấp không hợp lệ. Vui lòng nhập email hợp lệ.';
      case 'email-already-in-use':
        return 'Địa chỉ email đã được đăng ký. Vui lòng sử dụng email khác.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác. Vui lòng kiểm tra mật khẩu và thử lại.';
      case 'weak-password':
        return 'Mật khẩu quá yếu. Vui lòng chọn một mật khẩu mạnh hơn.';
      case 'provider-already-linked':
        return 'Tài khoản đã được liên kết với nhà cung cấp khác';
      case 'operation-not-allowed':
        return 'Không được phép thực hiện thao tác này. Liên hệ với bộ phận hỗ trợ để được trợ giúp.';
      case 'invalid-credential':
        return 'Thông tin xác thực được cung cấp bị lỗi hoặc đã hết hạn';
      case 'invalid-verification-code':
        return 'Mã xác minh không hợp lệ. Vui lòng nhập một mã hợp lệ.';
      case 'invalid-verification-id':
        return 'ID xác minh không hợp lệ. Vui lòng yêu cầu mã xác minh mới.';
      case 'captcha-check-failed':
        return 'Phản hồi reCAPTCHA không hợp lệ. Vui lòng thử lại.';
      case 'app-not-authorized':
        return 'Ứng dụng không được phép sử dụng Xác thực Firebase với khóa API được cung cấp';
      case 'keychain-error':
        return 'Đã xảy ra lỗi chuỗi khóa. Vui lòng kiểm tra chuỗi khóa và thử lại.';
      case 'internal-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'invalid-error':
        return 'Đã xảy ra lỗi xác thực nội bộ. Vui lòng thử lại sau.';
      case 'invalid-app-credential':
        return 'Thông tin xác thực ứng dụng không hợp lệ. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'user-mismatch':
        return 'Thông tin đăng nhập được cung cấp không khớp với người dùng đã đăng nhập trước đó.';
      case 'requires-recent-login':
        return 'Thao tác này yêu cầu xác thực gần đây do tính nhạy cảm. Vui lòng đăng nhập lại.';
      case 'quota-exceeded':
        return 'Đã vượt quá hạn. Vui lòng thử lại sau.';
      case 'account-exists-with-different-credential':
        return 'Một tài khoản đã tồn tại với cùng một email nhưng thông tin đăng nhập khác nhau.';
      case 'missing-iframe-start':
        return 'Email thiếu thẻ bắt đầu iframe.';
      case 'missing-iframe-end':
        return 'Email thiếu thẻ kết thúc iframe.';
      case 'missing-iframe-src':
        return 'Email thiếu thuộc tính iframe src.';
      case 'auth-domain-config-required':
        return 'Cần có cấu hình authDomain cho liên kết xác minh mã hành động';
      case 'missing-app-credential':
        return 'Thông tin xác thực ứng dụng bị thiếu. Vui lòng cung cấp thông tin xác thực ứng dụng hợp lệ.';
      case 'session-cookie-expired':
        return 'Cookie phiên Firebase đã hết hạn. Vui lòng đăng nhập lại.';
      case 'uid-already-exists':
        return 'ID người dùng được cung cấp đã được người dùng khác sử dụng.';
      case 'web-storage-unsupported':
        return 'Bộ nhớ web không được hỗ trợ hoặc bị vô hiệu hóa.';
      case 'app-deleted':
        return 'Phiên bản FirebaseApp này đã bị xóa.';
      case 'user-token-mismatch':
        return 'Mã thông báo của người dùng được cung cấp không khớp với người dùng của người dùng được xác thực 10.1';
      case 'invalid-message-payload':
        return 'Tin nhắn xác minh email không hợp lệ';
      case 'invalid-sender':
        return 'Người gửi email không hợp lệ. Vui lòng xác minh email của người gửi.';
      case 'invalid-recipient-email':
        return 'Địa chỉ email người nhận không hợp lệ. Vui lòng cung cấp email người nhận hợp lệ';
      case 'missing-action-code':
        return 'Mã hoạt động bị thiếu. Vui lòng cung cấp mã hoạt động hợp lệ.';
      case 'user-token-expired':
        return 'Mã thông báo của người dùng đã hết hạn và cần phải xác thực lại. Vui lòng đăng nhập lại.';
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Thông tin đăng nhập không hợp lệ.';
      case 'expired-action-code':
        return 'Mã hoạt động đã hết hạn. Vui lòng yêu cầu mã hoạt động mới.';
      case 'invalid-action-code':
        return 'Mã hoạt động không hợp lệ. Vui lòng kiểm tra mã và thử lại.';
      case 'credential-already-in-use':
        return 'Thông tin xác thực này đã được liên kết với một tài khoản người dùng khác.';
      default:
        return 'Đã xảy ra lỗi Firebase không mong muốn. Vui lòng thử lại.';
    }
  }
}
