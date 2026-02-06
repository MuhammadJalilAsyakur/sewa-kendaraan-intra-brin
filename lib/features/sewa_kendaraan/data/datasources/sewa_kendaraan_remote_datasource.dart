import 'package:vehicle_rental/features/sewa_kendaraan/data/models/sewa_kendaraan_model.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

abstract class SewaKendaraanRemoteDatasource {
  Future<DataPemohon> getDataPemohon();
  Future<void> submitSewaKendaraan(SewaKendaraanModel model);
  Future<void> updateSewaKendaraan(String id, SewaKendaraan data);
}

class SewaKendaraanDataSourceImpl implements SewaKendaraanRemoteDatasource {
  final _submissionStream = BehaviorSubject<SewaKendaraanModel?>();

  Stream<SewaKendaraanModel?> watchLatestSubmission() =>
      _submissionStream.stream;

  @override
  Future<void> submitSewaKendaraan(SewaKendaraanModel model) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate printing payload to console
    print("Submitting to API: ${model.toJson()}");

    _submissionStream.add(model);
  }

  @override
  Future<DataPemohon> getDataPemohon() async {
    await Future.delayed(const Duration(seconds: 1));
    return const DataPemohon(
      nama: "Afrido Prayogi",
      nip: "1998041001402004",
      nomorHp: "085692165345",
      satuanKerja: "Pusat Data Dan Informasi",
    );
  }

  Future<List<SewaKendaraanModel>> getHistory() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      SewaKendaraanModel(
        dataPemohon: const DataPemohonModel(
          nama: "Afrido",
          nip: "123",
          nomorHp: "081",
          satuanKerja: "Pusdatin",
        ),
        kegiatanDanTujuan: const KegiatanDanTujuanModel(
          namaKegiatan: "Dinas Luar Kota",
          keperluan: "Rapat Koordinasi",
        ),
        waktuPeminjaman: WaktuPeminjamanModel(
          tanggalMulaiPinjam: DateTime(2026, 1, 10),
          tanggalSelesaiPinjam: DateTime(2026, 1, 12),
        ),
        administrasiInfo: const AdministrasiInfoModel(
          kawasan: '',
          nomorSuratPengantar: '',
          tanggalPermohonan: null,
          tanggalSuratPengantar: null,
          keteranganPemohon: '',
        ),
        dataPenanggungJawab: const DataPenanggungJawabModel(),
        dataPenumpangDanPengemudi: const DataPenumpangDanPengemudiModel(),
        dokumenPersyaratan: const DokumenPersyaratanModel(),
      ),
    ];
  }

  @override
  Future<void> updateSewaKendaraan(String id, SewaKendaraan data) async {
    print('✏️ UPDATE LOCAL ONLY (API belum ada) - ID: $id');
  }
}
