// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vlu_project_1/features/medicien/models/medicien.dart';


class MedicineController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách tất cả thuốc
  Stream<List<Medicine>> getMedicines() {
    return _firestore.collection('Medicines').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Medicine.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // Tìm kiếm thuốc theo tên, bệnh và công dụng
  Stream<List<Medicine>> searchMedicines(String query) {
    return _firestore
        .collection('Medicines')
        .where('tenThuoc', isGreaterThanOrEqualTo: query)
        .where('tenThuoc', isLessThanOrEqualTo: '${query}\uf8ff')
        .snapshots()
        .map((snapshot) {
          final medicines = snapshot.docs.map((doc) => Medicine.fromMap(doc.data(), doc.id)).toList();

          return medicines.where((medicine) {
            return medicine.benh.contains(query) || medicine.congDung.contains(query);
          }).toList();
        });
  }

  // Thêm hoặc cập nhật thuốc
  Future<void> addOrUpdateMedicine(Medicine medicine) async {
    if (medicine.id.isEmpty) {
      await _firestore.collection('Medicines').add(medicine.toMap());
    } else {
      await _firestore.collection('Medicines').doc(medicine.id).update(medicine.toMap());
    }
  }

  // Xóa thuốc
  Future<void> deleteMedicine(String id) async {
    await _firestore.collection('Medicines').doc(id).delete();
  }
}
