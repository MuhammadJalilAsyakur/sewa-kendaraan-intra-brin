import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/section_card.dart'; // import SectionCard

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
    namaPJController = TextEditingController(
      text: p.dataPenanggungJawab.namaPenanggungJawab,
    );
    hpPJController = TextEditingController(
      text: p.dataPenanggungJawab.nomorHpPenanggungJawab,
    );
    emailPJController = TextEditingController(
      text: p.dataPenanggungJawab.email,
    );
    namaKegiatanController = TextEditingController(
      text: p.kegiatanDanTujuan.namaKegiatan,
    );
    keperluanController = TextEditingController(
      text: p.kegiatanDanTujuan.keperluan,
    );
    tujuanController = TextEditingController(
      text: p.kegiatanDanTujuan.tujuanPerjalanan,
    );
    jumlahPenumpangController = TextEditingController(
      text: p.dataPenumpangDanPengemudi.jumlahPenumpang?.toString() ?? '',
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
    final waktuPeminjaman = provider.waktuPeminjaman;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Data Penanggung Jawab
            SectionCard(
              title: 'Data Penanggung Jawab',
              icon: Icons.person_outline_rounded,
              iconColor: const Color(0xFF1565C0),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama Penanggung Jawab*',
                    hint: 'Masukan nama penanggung jawab',
                    controller: namaPJController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Nama penanggung jawab wajib diisi'
                        : null,
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
                    label: 'Nomor Ponsel Penanggung Jawab*',
                    hint: 'Masukan nomor ponsel',
                    controller: hpPJController,
                    keyboardType: TextInputType.phone,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Nomor ponsel wajib diisi'
                        : null,
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
                    hint: 'Masukan email',
                    controller: emailPJController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Email wajib diisi' : null,
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

            // Kegiatan dan Tujuan
            SectionCard(
              title: 'Kegiatan dan Tujuan',
              icon: Icons.directions_car_outlined,
              iconColor: const Color(0xFF2E7D32),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nama Kegiatan*',
                    hint: 'Masukan nama kegiatan',
                    controller: namaKegiatanController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Nama kegiatan wajib diisi'
                        : null,
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        current.copyWith(namaKegiatan: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Keperluan*',
                    hint: 'Dinas / Operasional / Antar jemput',
                    controller: keperluanController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Keperluan wajib diisi'
                        : null,
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        current.copyWith(keperluan: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Tujuan Perjalanan*',
                    hint: 'Masukan tujuan perjalanan',
                    controller: tujuanController,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Tujuan perjalanan wajib diisi'
                        : null,
                    onChanged: (val) {
                      final current = context
                          .read<SewaKendaraanProvider>()
                          .kegiatanDanTujuan;
                      provider.updateKegiatanDanTujuan(
                        current.copyWith(tujuanPerjalanan: val),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Waktu Peminjaman
            SectionCard(
              title: 'Waktu Peminjaman',
              icon: Icons.access_time_rounded,
              iconColor: const Color(0xFF6A1B9A),
              child: Column(
                children: [
                  CustomDateTimePicker(
                    label: 'Tanggal Mulai Pinjam*',
                    hint: 'mm/dd/yy --:-- --',
                    withTime: true,
                    value: waktuPeminjaman.tanggalMulaiPinjam,
                    validator: (val) =>
                        val == null ? 'Tanggal mulai pinjam wajib diisi' : null,
                    onChanged: (val) {
                      provider.updateWaktuPeminjaman(
                        waktuPeminjaman.copyWith(tanggalMulaiPinjam: val),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDateTimePicker(
                    label: 'Tanggal Selesai Pinjam*',
                    hint: 'mm/dd/yy --:-- --',
                    withTime: true,
                    value: waktuPeminjaman.tanggalSelesaiPinjam,
                    minDate: waktuPeminjaman.tanggalMulaiPinjam,
                    validator: (val) {
                      if (val == null)
                        return 'Tanggal selesai pinjam wajib diisi';
                      final mulai = waktuPeminjaman.tanggalMulaiPinjam;
                      if (mulai != null && val.isBefore(mulai)) {
                        return 'Tidak boleh sebelum tanggal mulai';
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

            // Penumpang & Pengemudi
            SectionCard(
              title: 'Penumpang & Pengemudi',
              icon: Icons.group_outlined,
              iconColor: const Color(0xFFE65100),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Jumlah Penumpang*',
                    hint: 'Masukan jumlah penumpang',
                    controller: jumlahPenumpangController,
                    keyboardType: TextInputType.number,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Jumlah penumpang wajib diisi'
                        : null,
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
                    value: provider.dataPenumpangDanPengemudi.statusPengemudi,
                    validator: (val) =>
                        val == null ? 'Status pengemudi wajib diisi' : null,
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
    );
  }
}
