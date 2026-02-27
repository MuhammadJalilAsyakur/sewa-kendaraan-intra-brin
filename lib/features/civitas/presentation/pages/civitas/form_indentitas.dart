import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/widgets/info_chip.dart';
import 'package:vehicle_rental/features/civitas/presentation/widgets/readonly_date_field.dart';
import 'package:vehicle_rental/features/civitas/presentation/widgets/section_card.dart';
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Card Data Pemohon
              SectionCard(
                title: 'Data Pemohon',
                icon: Icons.person_outline_rounded,
                iconColor: const Color(0xFF1565C0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + nama + nip
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              dataPemohon.nama.isNotEmpty
                                  ? dataPemohon.nama[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dataPemohon.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'NIP ${dataPemohon.nip}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    // Nomor HP
                    InfoChip(
                      icon: Icons.phone_outlined,
                      label: dataPemohon.nomorHp,
                    ),
                    const SizedBox(height: 8),

                    // Satuan Kerja
                    InfoChip(
                      icon: Icons.business_outlined,
                      label: dataPemohon.satuanKerja,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Card Informasi Administrasi
              SectionCard(
                title: 'Informasi Administrasi',
                icon: Icons.admin_panel_settings_outlined,
                iconColor: const Color(0xFFD32F2F),
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
                        if (value == null) return 'Kawasan wajib diisi ya';
                        return null;
                      },
                      onChanged: (val) {
                        provider.updateAdminsitrasiInfo(
                          adminInfo.copyWith(kawasan: val),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ReadonlyDateField(
                      label: 'Tanggal Permohonan*',
                      value: adminInfo.tanggalPermohonan,
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
                      hint: 'Masukan keterangan (opsional)',
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

              // Button Selanjutnya
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      provider.nextStep();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text('Mohon lengkapi data yang wajib diisi'),
                            ],
                          ),
                          backgroundColor: const Color(0xFFD32F2F),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selanjutnya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
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
}
