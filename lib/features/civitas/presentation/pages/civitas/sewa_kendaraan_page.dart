import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_detail.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_dokumen.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_indentitas.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/step_indicator.dart';

class SewaKendaraanPage extends StatelessWidget {
  const SewaKendaraanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SewaKendaraanController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (controller.currentStep > 0) {
              controller.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Peminjaman kendaraan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        return SafeArea(
          child: Column(
            children: [
              StepIndicator(
                currentStep: controller.currentStep,
                steps: const ['Indentitas', 'Detail', 'Dokumen'],
              ),
              Expanded(
                child: IndexedStack(
                  index: controller.currentStep,
                  children: const [
                    FormIndentitas(),
                    FormDetail(),
                    FormDokumen(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
