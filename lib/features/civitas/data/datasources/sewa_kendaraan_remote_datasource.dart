import 'package:dio/dio.dart';
import 'package:vehicle_rental/core/constants/api_constanst.dart';
import 'package:vehicle_rental/core/shared/submission_store.dart';
import 'package:vehicle_rental/features/civitas/data/models/sewa_kendaraan_model.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

abstract class SewaKendaraanRemoteDatasource {
  Future<DataPemohon> getDataPemohon();
  Future<void> submitSewaKendaraan(SewaKendaraanModel model);
  Future<void> updateSewaKendaraan(String id, SewaKendaraan data);
}

class SewaKendaraanDataSourceImpl implements SewaKendaraanRemoteDatasource {
  final Dio dio;
  final _submissionStream = BehaviorSubject<SewaKendaraanModel?>();

  Stream<SewaKendaraanModel?> watchLatestSubmission() =>
      _submissionStream.stream;

  SewaKendaraanDataSourceImpl({required this.dio});

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
    // final response = await dio.get(ApiConstants.sewaKendaraan);

    // return (response.data as List)
    //     .map((e) => SewaKendaraanModel.fromJson(e))
    //     .toList();
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

  // @override
  // Future<void> submitSewaKendaraan(SewaKendaraanModel model) async {
  //   await dio.post(
  //     ApiConstants.sewaKendaraan,
  //     data: {
  //       'mst_kawasan_id': model.administrasiInfo.kawasan,
  //       'nm_kegiatan': model.kegiatanDanTujuan.namaKegiatan,
  //       'tgl_mulai_pinjam': model.waktuPeminjaman.tanggalMulaiPinjam
  //           ?.toIso8601String(),
  //       'tgl_akhir_pinjam': model.waktuPeminjaman.tanggalSelesaiPinjam
  //           ?.toIso8601String(),
  //       'tujuan': model.kegiatanDanTujuan.tujuanPerjalanan,
  //       'mst_katalog_id': null,
  //       'mst_proses_id': null,
  //       'mst_tusi_id': null,
  //       'mst_kendaraan_id': null,
  //       'mst_pengemudi_id': null,
  //     },
  //   );
  //   _submissionStream.add(model);
  // }

  @override
  Future<void> submitSewaKendaraan(SewaKendaraanModel model) async {
    await Future.delayed(const Duration(seconds: 2));

    // Simulate printing payload to console
    print("Submitting to API: ${model.toJson()}");
    SubmissionStore().addSubmission(
      id: 'SK-${DateTime.now().millisecondsSinceEpoch}',
      namaPemohon: model.dataPemohon.nama,
      satuanKerja: model.dataPemohon.satuanKerja,
      keperluan: model.kegiatanDanTujuan.keperluan ?? '-',

      tanggalMulaiPinjam:
          model.waktuPeminjaman.tanggalMulaiPinjam ?? DateTime.now(),
      tanggalSelesaiPinjam:
          model.waktuPeminjaman.tanggalSelesaiPinjam ?? DateTime.now(),
    );

    _submissionStream.add(model);
  }

  @override
  Future<void> updateSewaKendaraan(String id, SewaKendaraan data) async {
    // await dio.put(
    //   '${ApiConstants.sewaKendaraan}/$id',
    //   data: {
    //     'nm_kegiatan': data.kegiatanDanTujuan.namaKegiatan,
    //     'tujuan': data.kegiatanDanTujuan.tujuanPerjalanan,
    //     'tgl_mulai_pinjam': data.waktuPeminjaman.tanggalMulaiPinjam
    //         ?.toIso8601String(),
    //     'tgl_akhir_pinjam': data.waktuPeminjaman.tanggalSelesaiPinjam
    //         ?.toIso8601String(),
    //   },
    // );
    print('✏️ UPDATE LOCAL ONLY (API belum ada) - ID: $id');
  }
}
