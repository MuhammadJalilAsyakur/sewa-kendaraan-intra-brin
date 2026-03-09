import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_date_time_picker.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/section_card.dart';

class FormDetail extends StatefulWidget {
  const FormDetail({super.key});

  @override
  State<FormDetail> createState() => _FormDetail();
}

class _FormDetail extends State<FormDetail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SewaKendaraanController _controller =
      Get.find<SewaKendaraanController>();

  late TextEditingController namaPJController;
  late TextEditingController hpPJController;
  late TextEditingController emailPJController;
  late TextEditingController namaKegiatanController;
  late TextEditingController keperluanController;
  late TextEditingController tujuanController;
  late TextEditingController jumlahPenumpangController;

  final List<Worker> _workers = [];

  @override
  void initState() {
    super.initState();

    namaPJController = TextEditingController(
      text: _controller.dataPenanggungJawab.namaPenanggungJawab,
    );
    hpPJController = TextEditingController(
      text: _controller.dataPenanggungJawab.nomorHpPenanggungJawab,
    );
    emailPJController = TextEditingController(
      text: _controller.dataPenanggungJawab.email,
    );
    namaKegiatanController = TextEditingController(
      text: _controller.kegiatanDanTujuan.namaKegiatan,
    );
    keperluanController = TextEditingController(
      text: _controller.kegiatanDanTujuan.keperluan,
    );
    tujuanController = TextEditingController(
      text: _controller.kegiatanDanTujuan.tujuanPerjalanan,
    );
    jumlahPenumpangController = TextEditingController(
      text:
          _controller.dataPenumpangDanPengemudi.jumlahPenumpang?.toString() ??
          '',
    );

    _workers.add(
      ever(_controller.dataPenanggungJawabRx, (_) => _syncControllers()),
    );
    _workers.add(
      ever(_controller.kegiatanDanTujuanRx, (_) => _syncControllers()),
    );
    _workers.add(
      ever(_controller.dataPenumpangDanPengemudiRx, (_) => _syncControllers()),
    );
  }

  @override
  void dispose() {
    for (final w in _workers) {
      w.dispose();
    }
    namaPJController.dispose();
    hpPJController.dispose();
    emailPJController.dispose();
    namaKegiatanController.dispose();
    keperluanController.dispose();
    tujuanController.dispose();
    jumlahPenumpangController.dispose();
    super.dispose();
  }

  void _syncControllers() {
    if (namaPJController.text !=
        (_controller.dataPenanggungJawab.namaPenanggungJawab ?? '')) {
      namaPJController.text =
          _controller.dataPenanggungJawab.namaPenanggungJawab ?? '';
    }
    if (hpPJController.text !=
        (_controller.dataPenanggungJawab.nomorHpPenanggungJawab ?? '')) {
      hpPJController.text =
          _controller.dataPenanggungJawab.nomorHpPenanggungJawab ?? '';
    }
    if (emailPJController.text !=
        (_controller.dataPenanggungJawab.email ?? '')) {
      emailPJController.text = _controller.dataPenanggungJawab.email ?? '';
    }
    if (namaKegiatanController.text !=
        (_controller.kegiatanDanTujuan.namaKegiatan ?? '')) {
      namaKegiatanController.text =
          _controller.kegiatanDanTujuan.namaKegiatan ?? '';
    }
    if (keperluanController.text !=
        (_controller.kegiatanDanTujuan.keperluan ?? '')) {
      keperluanController.text = _controller.kegiatanDanTujuan.keperluan ?? '';
    }
    if (tujuanController.text !=
        (_controller.kegiatanDanTujuan.tujuanPerjalanan ?? '')) {
      tujuanController.text =
          _controller.kegiatanDanTujuan.tujuanPerjalanan ?? '';
    }
    if (jumlahPenumpangController.text !=
        (_controller.dataPenumpangDanPengemudi.jumlahPenumpang?.toString() ??
            '')) {
      jumlahPenumpangController.text =
          _controller.dataPenumpangDanPengemudi.jumlahPenumpang?.toString() ??
          '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final waktuPeminjaman = _controller.waktuPeminjaman;

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
                        final current = _controller.dataPenanggungJawab;
                        _controller.updateDataPenanggungJawab(
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
                        final current = _controller.dataPenanggungJawab;
                        _controller.updateDataPenanggungJawab(
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
                      validator: (val) => val == null || val.isEmpty
                          ? 'Email wajib diisi'
                          : null,
                      onChanged: (val) {
                        final current = _controller.dataPenanggungJawab;
                        _controller.updateDataPenanggungJawab(
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
                        final current = _controller.kegiatanDanTujuan;
                        _controller.updateKegiatanDanTujuan(
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
                        final current = _controller.kegiatanDanTujuan;
                        _controller.updateKegiatanDanTujuan(
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
                        final current = _controller.kegiatanDanTujuan;
                        _controller.updateKegiatanDanTujuan(
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
                      validator: (val) => val == null
                          ? 'Tanggal mulai pinjam wajib diisi'
                          : null,
                      onChanged: (val) {
                        _controller.updateWaktuPeminjaman(
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
                        _controller.updateWaktuPeminjaman(
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
                        final current = _controller.dataPenumpangDanPengemudi;
                        _controller.updateInfoPenumpang(
                          current.copyWith(jumlahPenumpang: int.tryParse(val)),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      label: 'Status Pengemudi*',
                      value:
                          _controller.dataPenumpangDanPengemudi.statusPengemudi,
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
                        final current = _controller.dataPenumpangDanPengemudi;
                        _controller.updateInfoPenumpang(
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
                      _controller.nextStep();
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
    });
  }
}
