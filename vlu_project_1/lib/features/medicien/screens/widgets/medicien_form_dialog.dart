// lib/features/medicien/screens/medicine_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:vlu_project_1/features/medicien/models/medicien.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/features/medicien/controllers/medicine_controller.dart';
import 'package:vlu_project_1/shared/size.dart';

class MedicineFormDialog extends StatefulWidget {
  final Medicine? medicine;

  const MedicineFormDialog({super.key, this.medicine});

  @override
  _MedicineFormDialogState createState() => _MedicineFormDialogState();
}

class _MedicineFormDialogState extends State<MedicineFormDialog> {
  late TextEditingController tenThuocController;
  late TextEditingController benhController;
  late TextEditingController lieuLuongController;
  late TextEditingController thoiGianUongController;
  late TextEditingController congDungController;

  @override
  void initState() {
    super.initState();
    tenThuocController = TextEditingController(text: widget.medicine?.tenThuoc ?? '');
    benhController = TextEditingController(text: widget.medicine?.benh ?? '');
    lieuLuongController = TextEditingController(text: widget.medicine?.lieuLuong ?? '');
    thoiGianUongController = TextEditingController(text: widget.medicine?.thoiGianUong ?? '');
    congDungController = TextEditingController(text: widget.medicine?.congDung ?? '');
  }

  @override
  void dispose() {
    tenThuocController.dispose();
    benhController.dispose();
    lieuLuongController.dispose();
    thoiGianUongController.dispose();
    congDungController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Center(child: Text(widget.medicine == null ? 'Thêm thuốc' : 'Sửa thuốc')),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: tenThuocController,
                decoration: const InputDecoration(
                  labelText: 'Tên thuốc',
                  prefixIcon: Icon(Icons.menu_open_outlined),
                ),
                validator: (value) => Validate.string(value, enableNullOrEmpty: false),
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              TextFormField(
                controller: benhController,
                decoration: const InputDecoration(
                  labelText: 'Bệnh',
                  prefixIcon: Icon(Icons.medical_information_outlined),
                ),
                validator: (value) => Validate.string(value, enableNullOrEmpty: false),
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              TextFormField(
                controller: lieuLuongController,
                decoration: const InputDecoration(
                  labelText: 'Liều lượng',
                  prefixIcon: Icon(Icons.adjust_outlined),
                ),
                validator: (value) => Validate.string(value, enableNullOrEmpty: false),
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              TextFormField(
                controller: thoiGianUongController,
                decoration: const InputDecoration(
                  labelText: 'Thời gian uống',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) => Validate.string(value, enableNullOrEmpty: false),
              ),
              const SizedBox(height: TSize.spaceBtwItems),
              TextFormField(
                controller: congDungController,
                decoration: const InputDecoration(
                  labelText: 'Công dụng',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (value) => Validate.string(value, enableNullOrEmpty: false),
              ),
              const SizedBox(height: TSize.spaceBtwItems),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    if (tenThuocController.text.isNotEmpty && benhController.text.isNotEmpty) {
                      final newMedicine = Medicine(
                        id: widget.medicine?.id ?? '',
                        tenThuoc: tenThuocController.text,
                        benh: benhController.text,
                        lieuLuong: lieuLuongController.text,
                        thoiGianUong: thoiGianUongController.text,
                        congDung: congDungController.text,
                      );
                
                      MedicineController().addOrUpdateMedicine(newMedicine);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.medicine == null ? 'Thêm thuốc' : 'Cập nhật thuốc'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

