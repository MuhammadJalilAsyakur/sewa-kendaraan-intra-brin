import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/repositories/sewa_kendaraan_repository.dart';

class SubmitSewaKendaraanUsecase {
  final SewaKendaraanRepository repository;

  SubmitSewaKendaraanUsecase({required this.repository});

  Future<void> call(SewaKendaraan request) async {
    //validasi bagian administrasi dan info
    final administrasiInfo = request.administrasiInfo;

    if (administrasiInfo.kawasan == null || administrasiInfo.kawasan!.isEmpty) {
      throw Exception('Kawasan wajib diisi');
    }

    if (administrasiInfo.tanggalPermohonan == null) {
      throw Exception('Tanggal permohonon wajib diisi');
    }

    if (administrasiInfo.nomorSuratPengantar == null ||
        administrasiInfo.nomorSuratPengantar!.isEmpty) {
      throw Exception('Nomor Surat Pengantar Wajib diisi');
    }

    if (administrasiInfo.tanggalSuratPengantar == null) {
      throw Exception('Tanggal surat pengantar wajib diisi');
    }

    //validasi bagian penananggung jawab
    final dataPenanggungJawab = request.dataPenanggungJawab;

    if (dataPenanggungJawab.namaPenanggungJawab == null ||
        dataPenanggungJawab.namaPenanggungJawab!.isEmpty) {
      throw Exception('Nama penanggung jawaban wajib diisi');
    }

    if (dataPenanggungJawab.nomorHpPenanggungJawab == null ||
        dataPenanggungJawab.nomorHpPenanggungJawab!.isEmpty) {
      throw Exception('Nomor ponsel penanggung jawab wajib diisi');
    }

    if (dataPenanggungJawab.email == null || dataPenanggungJawab.email!.isEmpty) {
      throw Exception('Email penanggung jawab wajib diisi');
    }

    //validasi kegiatan dan tujuan
    final kegiatanDanTujuan = request.kegiatanDanTujuan;

    if (kegiatanDanTujuan.namaKegiatan!.isEmpty ||
        kegiatanDanTujuan.namaKegiatan == null) {
      throw Exception('Nama kegiatan wajib diisi');
    }

    if (kegiatanDanTujuan.keperluan!.isEmpty ||
        kegiatanDanTujuan.keperluan == null) {
      throw Exception('Keperluan wajib diiisi');
    }

    if (kegiatanDanTujuan.tujuanPerjalanan!.isEmpty ||
        kegiatanDanTujuan.tujuanPerjalanan == null) {
      throw Exception('Tujuan perjalanan wajib diisii');
    }

    //validasi waktu peminjaman
    final waktuPeminjaman = request.waktuPeminjaman;

    if (waktuPeminjaman.tanggalMulaiPinjam == null) {
      throw Exception('Tanggal mulai peminjaman wajib diisi');
    }

    if (waktuPeminjaman.tanggalSelesaiPinjam == null) {
      throw Exception('Tanggal selesai peminjaman wajib diisi');
    }

    //validasi status penumpang dan pengemudi
    final infoPenumpang = request.dataPenumpangDanPengemudi;

    if (infoPenumpang.jumlahPenumpang == null ||
        infoPenumpang.jumlahPenumpang! <= 0) {
      throw Exception('Jumlah penumpang wajib diisi');
    }

    if (infoPenumpang.statusPengemudi == null ||
        infoPenumpang.statusPengemudi!.isEmpty) {
      throw Exception('Status pengemudi wajib diisi');
    }

    //validasi dokumen Persyaratan
    final dokumenPersyaratan = request.dokumenPersyaratan;

    if (dokumenPersyaratan.suratTugas == null) {
      throw Exception('Dokumen persyaratan wajib diisi');
    }

    return repository.submitSewaKendaraan(request);
  }
}
