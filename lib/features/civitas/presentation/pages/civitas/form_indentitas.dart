import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_dropdown.dart';

class FormIndentitas extends StatefulWidget {
  const FormIndentitas({super.key});

  @override
  State<FormIndentitas> createState() => _FormIndentitas();
}

class _FormIndentitas extends State<FormIndentitas> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nomorSuratController;
  late TextEditingController keteranganPemohonController;

  @override
  void initState() {
    super.initState();

    final p = context.read<SewaKendaraanProvider>();

    nomorSuratController = TextEditingController(
      text: p.administrasiInfo.nomorSuratPengantar ?? '',
    );

    keteranganPemohonController = TextEditingController(
      text: p.administrasiInfo.keteranganPemohon ?? '',
    );
  }

  @override
  void dispose() {
    nomorSuratController.dispose();
    keteranganPemohonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SewaKendaraanProvider>();
    final dataPemohon = provider.dataPemohon;
    final adminInfo = provider.administrasiInfo;

    if (dataPemohon == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildCard(
                title: 'Data Pemohon',
                isExpanded: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataPemohon.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "NIP ${dataPemohon.nip}",
                            style: const TextStyle(color: Color(0xFF5C5D60)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(dataPemohon.nomorHp),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.business,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dataPemohon.satuanKerja,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Informasi Administrasi',
                child: Column(
                  children: [
                    CustomDropdown<String>(
                      label: 'Kawasan*',
                      value: adminInfo.kawasan,
                      items: const [
                        DropdownMenuItem(
                          value: 'Puspitek',
                          child: Text('Puspitek'),
                        ),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Kawasan wajib diisi ya';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        provider.updateAdminsitrasiInfo(
                          adminInfo.copyWith(kawasan: val),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDateTimePicker(
                      label: 'Tanggal permohonan*',
                      hint: 'mm/dd/yy',
                      withTime: false,
                      value: adminInfo.tanggalPermohonan,
                      validator: (value) {
                        if (value == null) {
                          return 'Tanggal permohonan wajib diisi ya';
                        }
                        return null;
                      },
                      onChanged: (_) {},
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'No. Surat Pengantar*',
                      hint: 'Masukan nomor surat pengantar',
                      controller: nomorSuratController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor surat pengantar wajib diisi ya';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        provider.updateAdminsitrasiInfo(
                          adminInfo.copyWith(nomorSuratPengantar: val),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDateTimePicker(
                      label: 'Tanggal Surat Pengantar*',
                      hint: 'mm/dd/yy',
                      value: adminInfo.tanggalSuratPengantar,
                      withTime: false,
                      validator: (value) {
                        if (value == null) {
                          return 'Tanggal Surat Pengantar wajib diisi';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        provider.updateAdminsitrasiInfo(
                          adminInfo.copyWith(tanggalSuratPengantar: val),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Keterangan Permohonan',
                      hint: 'Masukan Keterangan',
                      maxLines: 3,
                      controller: keteranganPemohonController,
                      onChanged: (val) {
                        provider.updateAdminsitrasiInfo(
                          adminInfo.copyWith(keteranganPemohon: val),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.nextStep();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi data yang wajib diisi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Selanjutnya'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
    bool isExpanded = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1.0),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              Icon(
                isExpanded ? Icons.person : Icons.info,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
