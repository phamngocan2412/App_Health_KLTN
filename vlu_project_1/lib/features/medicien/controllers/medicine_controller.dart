// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vlu_project_1/features/medicien/models/medicien.dart';

class MedicineController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Medicine>> getMedicines() {
    final userId = _auth.currentUser!.uid;
    return _firestore
        .collection('Medicines')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Medicine.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
  // Tìm kiếm thuốc theo tên, bệnh và công dụng
  Stream<List<Medicine>> searchMedicines(String query) {
    return _firestore.collection('Medicines').snapshots().map((snapshot) {
      final medicines = snapshot.docs
          .map((doc) => Medicine.fromMap(doc.data(), doc.id))
          .toList();
      // Lọc tất cả các trường
      return medicines.where((medicine) {
        return medicine.tenThuoc.contains(query) ||
              medicine.benh.contains(query) ||
              medicine.lieuLuong.contains(query) ||
              medicine.thoiGianUong.contains(query) ||
              medicine.congDung.contains(query)||
              medicine.bacSi.contains(query)||
              medicine.diaDiem.contains(query);
              
      }).toList();
    });
  }



  // Thêm hoặc cập nhật thuốc
  Future<void> addOrUpdateMedicine(Medicine medicine) async {
    final userId = _auth.currentUser!.uid;
    final medicineData = medicine.toMap();
    medicineData['userId'] = userId; 
    if (medicine.id.isEmpty) {
      await _firestore.collection('Medicines').add(medicineData);
    } else {
      await _firestore.collection('Medicines').doc(medicine.id).update(medicineData);
    }
  }

  // Xóa thuốc
  Future<void> deleteMedicine(String id) async {
    await _firestore.collection('Medicines').doc(id).delete();
  }
}
