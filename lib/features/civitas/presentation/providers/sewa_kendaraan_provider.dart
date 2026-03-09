// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/civitas/domain/repositories/sewa_kendaraan_repository.dart';
import 'package:file_picker/file_picker.dart';

class SewaKendaraanController extends GetxController {
  final SewaKendaraanRepository repository;

  SewaKendaraanController({required this.repository}) {
    _administrasiInfo = AdministrasiInfo(tanggalPermohonan: DateTime.now()).obs;
  }

  @override
  void onInit() {
    super.onInit();
    _loadDatPemohon();
  }

  final _isEditMode = false.obs;
  final _editingId = Rxn<String>();

  bool get isEditMode => _isEditMode.value;
  String? get editingId => _editingId.value;

  final _currentStep = 0.obs;
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  final _dataPemohon = Rxn<DataPemohon>();
  late final Rx<AdministrasiInfo> _administrasiInfo;
  final _dataPenanggungJawab = const DataPenanggungJawab().obs;
  final _kegiatanDanTujuan = const KegiatanDanTujuan().obs;
  final _waktuPeminjaman = const WaktuPeminjaman().obs;
  final _dataPenumpangDanPengemudi = const DataPenumpangDanPengemudi().obs;
  final _dokumenPersyaratan = const DokumenPersyaratan().obs;

  // Expose Rx objects for listening from outside (e.g., Worker/ever)
  Rx<AdministrasiInfo> get administrasiInfoRx => _administrasiInfo;
  Rx<DataPenanggungJawab> get dataPenanggungJawabRx => _dataPenanggungJawab;
  Rx<KegiatanDanTujuan> get kegiatanDanTujuanRx => _kegiatanDanTujuan;
  Rx<DataPenumpangDanPengemudi> get dataPenumpangDanPengemudiRx =>
      _dataPenumpangDanPengemudi;

  bool get isLoading => _isLoading.value;
  int get currentStep => _currentStep.value;
  String? get error => _error.value;
  DataPemohon? get dataPemohon => _dataPemohon.value;
  AdministrasiInfo get administrasiInfo => _administrasiInfo.value;
  DataPenanggungJawab get dataPenanggungJawab => _dataPenanggungJawab.value;
  KegiatanDanTujuan get kegiatanDanTujuan => _kegiatanDanTujuan.value;
  WaktuPeminjaman get waktuPeminjaman => _waktuPeminjaman.value;
  DataPenumpangDanPengemudi get dataPenumpangDanPengemudi =>
      _dataPenumpangDanPengemudi.value;
  DokumenPersyaratan get dokumenPersyaratan => _dokumenPersyaratan.value;

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "-";
    return "${DateFormat('dd/MM/yyyy HH:mm').format(start)} S/D ${DateFormat('dd/MM/yyyy HH:mm').format(end)}";
  }

  Future<void> _loadDatPemohon() async {
    _isLoading.value = true;
    try {
      _dataPemohon.value = await repository.getDataPemohon();
    } catch (e) {
      print('error loading data pemohon: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void nextStep() {
    if (_currentStep.value < 2) {
      _currentStep.value++;
    }
  }

  void previousStep() {
    if (_currentStep.value > 0) {
      _currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep.value = step;
    }
  }

  void updateAdminsitrasiInfo(AdministrasiInfo info) {
    _administrasiInfo.value = info;
  }

  void updateDataPenanggungJawab(DataPenanggungJawab data) {
    _dataPenanggungJawab.value = data;
  }

  void updateKegiatanDanTujuan(KegiatanDanTujuan kegiatan) {
    _kegiatanDanTujuan.value = kegiatan;
    print('kegiatanDanTujuan updated: ${_kegiatanDanTujuan.value}');
  }

  void updateWaktuPeminjaman(WaktuPeminjaman waktu) {
    _waktuPeminjaman.value = waktu;
  }

  void updateInfoPenumpang(DataPenumpangDanPengemudi data) {
    _dataPenumpangDanPengemudi.value = data;
  }

  void updateDokumenPersyaratan(DokumenPersyaratan dokumen) {
    _dokumenPersyaratan.value = dokumen;
  }

  Future<Map<String, dynamic>?> submit() async {
    if (_isLoading.value) return null;

    _isLoading.value = true;
    _error.value = null;

    try {
      final requestData = SewaKendaraan(
        dataPemohon: dataPemohon!,
        administrasiInfo: administrasiInfo,
        dataPenanggungJawab: dataPenanggungJawab,
        kegiatanDanTujuan: kegiatanDanTujuan,
        waktuPeminjaman: waktuPeminjaman,
        dataPenumpangDanPengemudi: dataPenumpangDanPengemudi,
        dokumenPersyaratan: dokumenPersyaratan,
      );
      final id = _isEditMode.value
          ? _editingId.value!
          : 'SK-${DateTime.now().millisecondsSinceEpoch}';

      if (_isEditMode.value && _editingId.value != null) {
        await repository.updateSewaKendaraan(
          id: _editingId.value!,
          data: requestData,
        );
      } else {
        await repository.submitSewaKendaraan(requestData, id: id);
      }

      final trackingData = {
        'id': id,
        'isEdit': _isEditMode.value,
        'status': 'Menunggu Persetujuan',
        'tanggalPengajuan':
            administrasiInfo.tanggalPermohonan ?? DateTime.now(),
        'judul': 'Permohonan Peminjaman Kendaraan',
        'keperluan': kegiatanDanTujuan.keperluan ?? 'Dinas Operasional',
        'periode': _formatRange(
          waktuPeminjaman.tanggalMulaiPinjam,
          waktuPeminjaman.tanggalSelesaiPinjam,
        ),
        'detailData': requestData,
      };

      print("✅ Submit Berhasil! Submission ID: $id");

      return trackingData;
    } catch (e) {
      _error.value = e.toString();
      print("❌ Error pas submit: $e");
      return null;
    } finally {
      _isLoading.value = false;
    }
  }

  void loadForEdit(SewaKendaraan data, String id) {
    _isEditMode.value = true;
    _editingId.value = id;

    _administrasiInfo.value = data.administrasiInfo;
    _dataPenanggungJawab.value = data.dataPenanggungJawab;
    _kegiatanDanTujuan.value = data.kegiatanDanTujuan;
    _waktuPeminjaman.value = data.waktuPeminjaman;
    _dataPenumpangDanPengemudi.value = data.dataPenumpangDanPengemudi;
    _dokumenPersyaratan.value = data.dokumenPersyaratan;
  }

  Future<void> pickSuratTugas(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String fileName = result.files.first.name;
        updateDokumenPersyaratan(
          dokumenPersyaratan.copyWith(suratTugas: fileName),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void resetForm() {
    _isEditMode.value = false;
    _editingId.value = null;

    _administrasiInfo.value = AdministrasiInfo(
      tanggalPermohonan: DateTime.now(),
    );
    _dataPenanggungJawab.value = const DataPenanggungJawab();
    _kegiatanDanTujuan.value = const KegiatanDanTujuan();
    _waktuPeminjaman.value = const WaktuPeminjaman();
    _dataPenumpangDanPengemudi.value = const DataPenumpangDanPengemudi();
    _dokumenPersyaratan.value = const DokumenPersyaratan();
    _currentStep.value = 0;
  }
}
