// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/civitas/domain/repositories/sewa_kendaraan_repository.dart';
import 'package:file_picker/file_picker.dart';

class SewaKendaraanProvider extends ChangeNotifier {
  final SewaKendaraanRepository repository;

  SewaKendaraanProvider({required this.repository}) {
    _loadDatPemohon();
  }

  bool _isEditMode = false;
  String? _editingId;

  bool get isEditMode => _isEditMode;
  String? get editingId => _editingId;

  int _currentStep = 0;
  bool _isLoading = false;
  String? _error;

  DataPemohon? _dataPemohon;
  AdministrasiInfo _administrasiInfo = AdministrasiInfo(
    tanggalPermohonan: DateTime.now(),
  );
  DataPenanggungJawab _dataPenanggungJawab = const DataPenanggungJawab();
  KegiatanDanTujuan _kegiatanDanTujuan = const KegiatanDanTujuan();
  WaktuPeminjaman _waktuPeminjaman = const WaktuPeminjaman();
  DataPenumpangDanPengemudi _dataPenumpangDanPengemudi =
      const DataPenumpangDanPengemudi();
  DokumenPersyaratan _dokumenPersyaratan = const DokumenPersyaratan();

  bool get isLoading => _isLoading;
  int get currentStep => _currentStep;
  String? get error => _error;
  DataPemohon? get dataPemohon => _dataPemohon;
  AdministrasiInfo get administrasiInfo => _administrasiInfo;
  DataPenanggungJawab get dataPenanggungJawab => _dataPenanggungJawab;
  KegiatanDanTujuan get kegiatanDanTujuan => _kegiatanDanTujuan;
  WaktuPeminjaman get waktuPeminjaman => _waktuPeminjaman;
  DataPenumpangDanPengemudi get dataPenumpangDanPengemudi =>
      _dataPenumpangDanPengemudi;
  DokumenPersyaratan get dokumenPersyaratan => _dokumenPersyaratan;

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "-";
    return "${DateFormat('dd/MM/yyyy HH:mm').format(start)} S/D ${DateFormat('dd/MM/yyyy HH:mm').format(end)}";
  }

  Future<void> _loadDatPemohon() async {
    _isLoading = true;
    notifyListeners();
    try {
      _dataPemohon = await repository.getDataPemohon();
    } catch (e) {
      print('error loading data pemohon: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  void updateAdminsitrasiInfo(AdministrasiInfo info) {
    _administrasiInfo = info;
    notifyListeners();
  }

  void updateDataPenanggungJawab(DataPenanggungJawab data) {
    _dataPenanggungJawab = data;
    notifyListeners();
  }

  void updateKegiatanDanTujuan(KegiatanDanTujuan kegiatan) {
    _kegiatanDanTujuan = kegiatan;
    print('kegiatanDanTujuan updated: $_kegiatanDanTujuan');
    notifyListeners();
  }

  void updateWaktuPeminjaman(WaktuPeminjaman waktu) {
    _waktuPeminjaman = waktu;
    notifyListeners();
  }

  void updateInfoPenumpang(DataPenumpangDanPengemudi data) {
    _dataPenumpangDanPengemudi = data;
    notifyListeners();
  }

  void updateDokumenPersyaratan(DokumenPersyaratan dokumen) {
    _dokumenPersyaratan = dokumen;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> submit() async {
    if (_isLoading) return null;

    _isLoading = true;
    _error = null;
    notifyListeners();

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
      if (_isEditMode && _editingId != null) {
        await repository.updateSewaKendaraan(
          id: _editingId!,
          data: requestData,
        );
      } else {
        await repository.submitSewaKendaraan(requestData);
      }

      final id = _isEditMode
          ? _editingId!
          : 'SK-${DateTime.now().millisecondsSinceEpoch}';

      final trackingData = {
        'id': id,
        'isEdit': _isEditMode,
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
      _error = e.toString();
      print("❌ Error pas submit: $e");
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void loadForEdit(SewaKendaraan data, String id) {
    _isEditMode = true;
    _editingId = id;

    _administrasiInfo = data.administrasiInfo;
    _dataPenanggungJawab = data.dataPenanggungJawab;
    _kegiatanDanTujuan = data.kegiatanDanTujuan;
    _waktuPeminjaman = data.waktuPeminjaman;
    _dataPenumpangDanPengemudi = data.dataPenumpangDanPengemudi;
    _dokumenPersyaratan = data.dokumenPersyaratan;

    notifyListeners();
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
    _isEditMode = false;
    _editingId = null;

    _administrasiInfo = AdministrasiInfo(tanggalPermohonan: DateTime.now());
    _dataPenanggungJawab = const DataPenanggungJawab();
    _kegiatanDanTujuan = const KegiatanDanTujuan();
    _waktuPeminjaman = const WaktuPeminjaman();
    _dataPenumpangDanPengemudi = const DataPenumpangDanPengemudi();
    _dokumenPersyaratan = const DokumenPersyaratan();
    _currentStep = 0;

    notifyListeners();
  }
}
