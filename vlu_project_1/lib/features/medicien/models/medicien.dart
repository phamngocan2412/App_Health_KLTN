// lib/features/medicien/models/medicien.dart
class Medicine {
  final String id;
  final String tenThuoc;
  final String benh;
  final String bacSi;
  final String diaDiem;
  final String lieuLuong;
  final String thoiGianUong;
  final String congDung;
  final String sdt;

  Medicine({
    required this.id,
    required this.tenThuoc,
    required this.benh,
    required this.lieuLuong,
    required this.thoiGianUong,
    required this.congDung,
    required this.bacSi,
    required this.diaDiem,
    required this.sdt,
  });

  Map<String, dynamic> toMap() {
    return {
      'tenThuoc': tenThuoc,
      'benh': benh,
      'lieuLuong': lieuLuong,
      'thoiGianUong': thoiGianUong,
      'congDung': congDung,
      'bacSi': bacSi,
      'diaDiem': diaDiem,
      'sdt': sdt,
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
      bacSi: data['bacSi'] ?? '',
      diaDiem: data['diaDiem'] ?? '',
      sdt: data['sdt'] ?? 0,
    );
  }
}
