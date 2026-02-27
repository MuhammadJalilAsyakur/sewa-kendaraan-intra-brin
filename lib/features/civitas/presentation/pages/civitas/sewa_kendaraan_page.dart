import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_detail.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_dokumen.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_indentitas.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/step_indicator.dart';


class SewaKendaraanPage extends StatelessWidget {
  const SewaKendaraanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final provider = context.read<SewaKendaraanProvider>();
            if (provider.currentStep > 0) {
              provider.previousStep();
            } else {
              // Handle Back navigation if needed
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
      body: Consumer<SewaKendaraanProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: Column(
              children: [
                StepIndicator(
                  currentStep: provider.currentStep,
                  steps: const ['Indentitas', 'Detail', 'Dokumen'],
                ),
                Expanded(
                  child: IndexedStack(
                    index: provider.currentStep,
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
        },
      ),
    );
  }
}
