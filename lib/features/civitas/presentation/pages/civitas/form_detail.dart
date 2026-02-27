import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_dropdown.dart';

class FormDetail extends StatefulWidget {
  const FormDetail({super.key});

  @override
  State<FormDetail> createState() => _FormDetail();
}

class _FormDetail extends State<FormDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController namaPJController;
  late TextEditingController hpPJController;
  late TextEditingController emailPJController;

  late TextEditingController namaKegiatanController;
  late TextEditingController keperluanController;
  late TextEditingController tujuanController;

  late TextEditingController jumlahPenumpangController;

  @override
  void initState() {
    super.initState();

    final p = context.read<SewaKendaraanProvider>();

    // ===== Penanggung Jawab =====
    namaPJController = TextEditingController(
      text: p.dataPenanggungJawab.namaPenanggungJawab,
    );
    hpPJController = TextEditingController(
      text: p.dataPenanggungJawab.nomorHpPenanggungJawab,
    );
    emailPJController = TextEditingController(
      text: p.dataPenanggungJawab.email,
    );

    // ===== Kegiatan =====
    namaKegiatanController = TextEditingController(
      text: p.kegiatanDanTujuan.namaKegiatan,
    );
    keperluanController = TextEditingController(
      text: p.kegiatanDanTujuan.keperluan,
    );
    tujuanController = TextEditingController(
      text: p.kegiatanDanTujuan.tujuanPerjalanan,
    );

    // ===== Penumpang =====
    jumlahPenumpangController = TextEditingController(
      text: p.dataPenumpangDanPengemudi.jumlahPenumpang?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    namaPJController.dispose();
    hpPJController.dispose();
    emailPJController.dispose();
    namaKegiatanController.dispose();
    keperluanController.dispose();
    tujuanController.dispose();
    jumlahPenumpangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SewaKendaraanProvider>();
    // final penananggungJawab = provider.dataPenanggungJawab;
    // final kegiatan = provider.kegiatanDanTujuan;
    final waktuPeminjaman = provider.waktuPeminjaman;
    // final penumpang = provider.dataPenumpangDanPengemudi;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildCard(
              title: 'Data Penanggung jawab',
              icon: Icons.person,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama Penanggung Jawab*',
                    hint: 'Masukan nama penanggung Jawab',
                    controller: namaPJController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'nama penanggung Jawab wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .dataPenanggungJawab;
                      provider.updateDataPenanggungJawab(
                        current.copyWith(namaPenanggungJawab: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Nomor ponsel Penanggung Jawab*',
                    hint: 'Masukan nomor ponsel penanggung Jawab',
                    controller: hpPJController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor ponsel Penanggung Jawab wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .dataPenanggungJawab;
                      provider.updateDataPenanggungJawab(
                        current.copyWith(nomorHpPenanggungJawab: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email Penanggung Jawab*',
                    hint: 'Masukan email penanggung Jawab',
                    controller: emailPJController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email Penanggung Jawab wajib diisi ya';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .dataPenanggungJawab;
                      provider.updateDataPenanggungJawab(
                        current.copyWith(email: val),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Kegiatan dan tujuan',
              icon: Icons.directions_car,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama Kegiatan*',
                    hint: 'Masukan nama kegiatan',
                    controller: namaKegiatanController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama Kegiatan wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final currentKegiatan = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        currentKegiatan.copyWith(namaKegiatan: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Keperluan (Dinas/Operasional/Antar jemput) *',
                    hint: 'Masukan keperluan',
                    controller: keperluanController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Keperluan wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final currentKegiatan = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        currentKegiatan.copyWith(keperluan: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Tujuan Perjalanan*',
                    hint: 'Masukan tujuan perjalanan',
                    controller: tujuanController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tujuan Perjalanan wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final currentKegiatan = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        currentKegiatan.copyWith(tujuanPerjalanan: val),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Waktu peminjaman',
              icon: Icons.access_time,
              child: Column(
                children: [
                  CustomDateTimePicker(
                    label: 'Tanggal mulai pinjam*',
                    hint: 'mm/dd/yy --:-- --',
                    withTime: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Tanggal mulai pinjam wajib diisi';
                      }

                      return null;
                    },
                    value: waktuPeminjaman.tanggalMulaiPinjam,
                    onChanged: (val) {
                      provider.updateWaktuPeminjaman(
                        waktuPeminjaman.copyWith(tanggalMulaiPinjam: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDateTimePicker(
                    label: 'Tanggal selesai pinjam*',
                    hint: 'mm/dd/yy --:-- --',
                    withTime: true,
                    value: waktuPeminjaman.tanggalSelesaiPinjam,
                    minDate: waktuPeminjaman.tanggalMulaiPinjam,
                    validator: (value) {
                      if (value == null) {
                        return 'Tanggal selesai pinjam wajib diisi';
                      }

                      final mulai = waktuPeminjaman.tanggalMulaiPinjam;

                      if (mulai != null && value.isBefore(mulai)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Tanggal selesai pinjam tidak boleh sebelum tanggal mulai',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return 'Tanggal selesai pinjam tidak boleh sebelum tanggal mulai';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      provider.updateWaktuPeminjaman(
                        waktuPeminjaman.copyWith(tanggalSelesaiPinjam: val),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCard(
              title: 'Penumpang & Pengemudi',
              icon: Icons.group,
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Jumlah Penumpang*',
                    hint: 'Masukan jumlah penumpang',
                    controller: jumlahPenumpangController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah Penumpang wajib diisi ya';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .dataPenumpangDanPengemudi;
                      provider.updateInfoPenumpang(
                        current.copyWith(jumlahPenumpang: int.tryParse(val)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown<String>(
                    label: 'Status Pengemudi*',
                    value: context
                        .read<SewaKendaraanProvider>()
                        .dataPenumpangDanPengemudi
                        .statusPengemudi,
                    validator: (value) {
                      if (value == null) return 'Status Pengemudi wajib diisi';
                      return null;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Dengan pengemudi',
                        child: Text('Dengan pengemudi'),
                      ),
                      DropdownMenuItem(
                        value: 'Tanpa pengemudi',
                        child: Text('Tanpa pengemudi'),
                      ),
                    ],
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .dataPenumpangDanPengemudi;
                      provider.updateInfoPenumpang(
                        current.copyWith(statusPengemudi: val),
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
              child: ElevatedButton.icon(
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
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Selanjutnya'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Row(
            children: [
              Icon(icon, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
