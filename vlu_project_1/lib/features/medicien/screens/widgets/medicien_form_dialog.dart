import 'package:flutter/material.dart';
import 'package:vlu_project_1/features/medicien/models/medicien.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/medicien/controllers/medicine_controller.dart';
import 'package:vlu_project_1/shared/size.dart';

class MedicineFormDialog extends StatefulWidget {
  final Medicine? medicine;

  const MedicineFormDialog({super.key, this.medicine});

  @override
  MedicineFormDialogState createState() => MedicineFormDialogState();
}

class MedicineFormDialogState extends State<MedicineFormDialog> {
  late TextEditingController tenThuocController;
  late TextEditingController benhController;
  late TextEditingController lieuLuongController;
  late TextEditingController thoiGianUongController;
  late TextEditingController congDungController;
  late TextEditingController bacSiController;
  late TextEditingController diaDiemController;
  late TextEditingController sdtController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tenThuocController = TextEditingController(text: widget.medicine?.tenThuoc ?? '');
    benhController = TextEditingController(text: widget.medicine?.benh ?? '');
    lieuLuongController = TextEditingController(text: widget.medicine?.lieuLuong ?? '');
    thoiGianUongController = TextEditingController(text: widget.medicine?.thoiGianUong ?? '');
    congDungController = TextEditingController(text: widget.medicine?.congDung ?? '');
    bacSiController = TextEditingController(text: widget.medicine?.bacSi ?? '');
    diaDiemController = TextEditingController(text: widget.medicine?.diaDiem ?? '');
    sdtController = TextEditingController(text: widget.medicine?.sdt ?? '');
  }

  @override
  void dispose() {
    tenThuocController.dispose();
    benhController.dispose();
    lieuLuongController.dispose();
    thoiGianUongController.dispose();
    congDungController.dispose();
    bacSiController.dispose();
    diaDiemController.dispose();
    sdtController.dispose();
    super.dispose();
  }

  void _updateMedicine() {
    if (_formKey.currentState?.validate() ?? false) {
      final newMedicine = Medicine(
        id: widget.medicine?.id ?? '',
        tenThuoc: tenThuocController.text,
        benh: benhController.text,
        lieuLuong: lieuLuongController.text,
        thoiGianUong: thoiGianUongController.text,
        congDung: congDungController.text,
        bacSi: bacSiController.text,
        diaDiem: diaDiemController.text,
        sdt: sdtController.text,
      );
      MedicineController().addOrUpdateMedicine(newMedicine);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text(widget.medicine == null ? 'Thêm thuốc' : 'Sửa thuốc')),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                TextFormField(
                  controller: tenThuocController,
                  decoration: const InputDecoration(
                    labelText: 'Tên thuốc',
                    prefixIcon: Icon(Icons.menu_open_outlined),
                  ),
                  validator: (value) => Validate.tenThuoc(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: benhController,
                  decoration: const InputDecoration(
                    labelText: 'Bệnh',
                    prefixIcon: Icon(Icons.medical_information_outlined),
                  ),
                  validator: (value) => Validate.benh(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: lieuLuongController,
                  decoration: const InputDecoration(
                    labelText: 'Liều lượng',
                    prefixIcon: Icon(Icons.adjust_outlined),
                  ),
                  validator: (value) => Validate.lieuLuong(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: thoiGianUongController,
                  decoration: const InputDecoration(
                    labelText: 'Thời gian uống',
                    prefixIcon: Icon(Icons.access_time),
                  ),
                  validator: (value) => Validate.thoiGianUong(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: congDungController,
                  decoration: const InputDecoration(
                    labelText: 'Công dụng',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  validator: (value) => Validate.congDung(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: bacSiController,
                  decoration: const InputDecoration(
                    labelText: 'Bác sĩ',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => Validate.bacSi(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: diaDiemController,
                  decoration: const InputDecoration(
                    labelText: 'Địa điểm',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  validator: (value) => Validate.diaDiem(value, enableNullOrEmpty: false),
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                TextFormField(
                  controller: sdtController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (text) {
                    return Validate.phone(text, enableNullOrEmpty: false);
                  },
                ),
                const SizedBox(height: TSize.spaceBtwItems),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _updateMedicine();
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.medicine == null ? 'Thêm thuốc' : 'Cập nhật thuốc'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
