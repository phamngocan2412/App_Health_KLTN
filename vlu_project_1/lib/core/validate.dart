import 'package:easy_localization/easy_localization.dart';

class Validate {
  final emptyConditions = ['', 0, []];

  bool isNullOrEmpty(dynamic obj) {
    return obj == null || emptyConditions.contains(obj);
  }

  static String? email(String? email, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(email)) {
      return null;
    }
    if (Validate().isNullOrEmpty(email)) {
      return 'Email chưa được nhập'.tr();
    }
    if (!isValidEmail(email!)) {
      return 'Làm ơn hãy nhập Email'.tr();
    }
    return null;
  }

  static String? phone(String? phone, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(phone)) {
      return null;
    }
    if (Validate().isNullOrEmpty(phone)) {
      return 'Nhập số điện thoại'.tr();
    }
    if (!isNumeric(phone ?? '0')) {
      return 'Chỉ nhập số'.tr(args: ['Số điện thoại'.tr()]);
    }
    if (phone!.length < 10 || phone.length > 11) {
      return 'Số điện thoại phải có độ dài từ 10 đến 11 ký tự'.tr();
    }
    if (!phone.startsWith('0')) {
      return 'Số điện thoại phải bắt đầu bằng số 0'.tr();
    }
    if (!isValidPhone(phone)) {
      return 'Điện thoại không hợp lệ'.tr();
    }
    return null;
  }

  static String? fax(String? fax, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(fax)) {
      return null;
    }
    if (!Validate().isNullOrEmpty(fax) && !isValidFax(fax!)) {
      return 'Fax không hợp lệ'.tr();
    }
    return null;
  }

  static String? pass(String? pass, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(pass)) {
      return null;
    }

    if (Validate().isNullOrEmpty(pass)) {
      return 'Mật khẩu chưa được nhập'.tr();
    }

    if (!isValidPass(pass!)) {
      final lengthValid = pass.length >= 8 && pass.length <= 16;
      final hasLetter = RegExp(r"[a-z]").hasMatch(pass);
      final hasNumber = RegExp(r"\d").hasMatch(pass);
      final hasSpecialChar = RegExp(r"[@$!%*#?&]").hasMatch(pass);
      final hasCapLetter = RegExp(r"[A-Z]").hasMatch(pass);

      if (!lengthValid) {
        return '- Ít nhất 8 ký tự'.tr();
      }
      if (!hasLetter) {
        return '- Ít nhất một chữ cái'.tr();
      }
      if (!hasNumber) {
        return '- Ít nhất một số'.tr();
      }
      if (!hasCapLetter) {
        return '- Ít nhất một chữ cái viết hoa'.tr();
      }
      if (!hasSpecialChar) {
        return '- Ít nhất một ký tự đặc biệt (@\$!%*#?&)'.tr();
      }
    }
    return null;
  }

  static String? number(
    String? number, {
    String fieldName = '',
    bool enableNullOrEmpty = false,
    String invalidMessage = 'Chỉ nhập số',
  }) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(number)) {
      return null;
    }

    if (Validate().isNullOrEmpty(number)) {
      return 'Số của bạn chưa được nhập'.tr(args: [fieldName.tr()]);
    }

    if (!isNumeric(number!)) {
      return invalidMessage.tr(args: [fieldName.tr()]);
    }

    return null;
  }

  static String? confirmPass(String? text,
      {required String pass,
      required String confirmPass,
      required String fieldName}) {
    if (text == null || text.isEmpty) {
      return null;
    }
    if (pass != confirmPass) {
      return 'Mật khẩu không khớp. Vui lòng gõ lại lần nữa.'.tr();
    }
    return null;
  }

  static String? firstName(String? firstName,
      {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(firstName)) {
      return null;
    }
    if (Validate().isNullOrEmpty(firstName)) {
      return 'Tên của bạn chưa được nhập'.tr();
    }
    return null;
  }
  

  static String? lastName(String? lastName, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(lastName)) {
      return null;
    }
    if (Validate().isNullOrEmpty(lastName)) {
      return 'Họ của bạn chưa được nhập'.tr();
    }
    return null;
  }

  static String? userName(String? userName, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(userName)) {
      return null;
    }
    if (Validate().isNullOrEmpty(userName)) {
      return 'Tên người dùng chưa được nhập'.tr();
    }
    return null;
  }

  static String? tenThuoc(String? tenThuoc,
      {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(tenThuoc)) {
      return null;
    }
    if (Validate().isNullOrEmpty(tenThuoc)) {
      return 'Tên thuốc chưa được nhập'.tr();
    }
    return null;
  }

  static String? benh(String? benh, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(benh)) {
      return null;
    }
    if (Validate().isNullOrEmpty(benh)) {
      return 'Bệnh chưa được nhập'.tr();
    }
    return null;
  }

  static String? lieuLuong(String? lieuLuong, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(lieuLuong)) {
      return null;
    }
    if (Validate().isNullOrEmpty(lieuLuong)) {
      return 'Liều lượng chưa được nhập'.tr();
    }
    return null;
  }

  static String? thoiGianUong(String? thoiGianUong, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(thoiGianUong)) {
      return null;
    }
    if (Validate().isNullOrEmpty(thoiGianUong)) {
      return 'Thời gian uống chưa được nhập'.tr();
    }
    return null;
  }

  static String? congDung(String? congDung, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(congDung)) {
      return null;
    }
    if (Validate().isNullOrEmpty(congDung)) {
      return 'Công dụng chưa được nhập'.tr();
    }
    return null;
  }

  static String? bacSi(String? bacSi, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(bacSi)) {
      return null;
    }
    if (Validate().isNullOrEmpty(bacSi)) {
      return 'Bác sĩ chưa được nhập'.tr();
    }
    return null;
  }

  static String? diaDiem(String? diaDiem, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(diaDiem)) {
      return null;
    }
    if (Validate().isNullOrEmpty(diaDiem)) {
      return 'Địa điểm chưa được nhập'.tr();
    }
    return null;
  }

  static String? string(String? text, {bool enableNullOrEmpty = false}) {
    if (enableNullOrEmpty && Validate().isNullOrEmpty(text)) {
      return null;
    }
    if (Validate().isNullOrEmpty(userName)) {
      return 'Bạn chưa nhập dữ liệu'.tr();
    }
    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  static bool isValidFax(String fax) {
    return RegExp(r'^\+?[0-9]{6,}$').hasMatch(fax);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)').hasMatch(phone);
  }

  static bool isValidPass(String pass) {
    return RegExp(
            r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
        .hasMatch(pass);
  }

  static bool isNumeric(String str) {
    if (str.endsWith('.')) {
      return false;
    }
    try {
      double.parse(str);
    } on FormatException {
      return false;
    }
    return true;
  }

  static bool isUuid(String uuid) {
    return RegExp(
            r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}')
        .hasMatch(uuid.toLowerCase());
  }

  static String? validateRequired(String? str, {required String fieldName}) {
    if (str == null || str.isEmpty) {
      return tr('Bắt buộc', args: [fieldName.tr().toLowerCase()]);
    }
    return null;
  }

  static String? validateRequiredCondition(bool isValid,
      {required String fieldName}) {
    if (!isValid) {
      return tr('Bắt buộc', args: [fieldName.tr()]);
    }
    return null;
  }
}
