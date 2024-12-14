
class Medicine {
  final String id;
  final String tenThuoc;
  final String benh;
  final String lieuLuong;
  final String thoiGianUong;
  final String congDung;

  Medicine({
    required this.id,
    required this.tenThuoc,
    required this.benh,
    required this.lieuLuong,
    required this.thoiGianUong,
    required this.congDung,
  });

  Map<String, dynamic> toMap() {
    return {
      'tenThuoc': tenThuoc,
      'benh': benh,
      'lieuLuong': lieuLuong,
      'thoiGianUong': thoiGianUong,
      'congDung': congDung,
    };
  }

  static Medicine fromMap(Map<String, dynamic> data, String documentId) {
    return Medicine(
      id: documentId,
      tenThuoc: data['tenThuoc'] ?? '',
      benh: data['benh'] ?? '',
      lieuLuong: data['lieuLuong'] ?? '',
      thoiGianUong: data['thoiGianUong'] ?? '',
      congDung: data['congDung'] ?? '',
    );
  }
}
