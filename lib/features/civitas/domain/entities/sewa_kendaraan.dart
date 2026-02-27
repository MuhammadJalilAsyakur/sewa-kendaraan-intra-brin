import 'package:equatable/equatable.dart';

class SewaKendaraan extends Equatable {
  final DataPemohon dataPemohon;
  final AdministrasiInfo administrasiInfo;
  final DataPenanggungJawab dataPenanggungJawab;
  final KegiatanDanTujuan kegiatanDanTujuan;
  final WaktuPeminjaman waktuPeminjaman;
  final DataPenumpangDanPengemudi dataPenumpangDanPengemudi;
  final DokumenPersyaratan dokumenPersyaratan;

  const SewaKendaraan({
    required this.dataPemohon,
    required this.administrasiInfo,
    required this.dataPenanggungJawab,
    required this.kegiatanDanTujuan,
    required this.waktuPeminjaman,
    required this.dataPenumpangDanPengemudi,
    required this.dokumenPersyaratan,
  });

  SewaKendaraan copyWith({
    DataPemohon? dataPemohon,
    AdministrasiInfo? administrasiInfo,
    DataPenanggungJawab? dataPenanggungJawab,
    KegiatanDanTujuan? kegiatanDanTujuan,
    WaktuPeminjaman? waktuPeminjaman,
    DataPenumpangDanPengemudi? dataPenumpangDanPengemudi,
    DokumenPersyaratan? dokumenPersyaratan,
  }) {
    return SewaKendaraan(
      dataPemohon: dataPemohon ?? this.dataPemohon,
      administrasiInfo: administrasiInfo ?? this.administrasiInfo,
      dataPenanggungJawab: dataPenanggungJawab ?? this.dataPenanggungJawab,
      kegiatanDanTujuan: kegiatanDanTujuan ?? this.kegiatanDanTujuan,
      waktuPeminjaman: waktuPeminjaman ?? this.waktuPeminjaman,
      dataPenumpangDanPengemudi: dataPenumpangDanPengemudi ?? this.dataPenumpangDanPengemudi,
      dokumenPersyaratan: dokumenPersyaratan ?? this.dokumenPersyaratan,
    );
  }

  @override
  List<Object?> get props => [
    dataPemohon,
    administrasiInfo,
    dataPenanggungJawab,
    kegiatanDanTujuan,
    waktuPeminjaman,
    dataPenumpangDanPengemudi,
    dokumenPersyaratan,
  ];
}

class DataPemohon extends Equatable {
  final String nama;
  final String nip;
  final String nomorHp;
  final String satuanKerja;

  const DataPemohon({
    required this.nama,
    required this.nip,
    required this.nomorHp,
    required this.satuanKerja,
  });

  @override
  List<Object?> get props => [nama, nip, nomorHp, satuanKerja];
}

class AdministrasiInfo extends Equatable {
  final String? kawasan;
  final DateTime? tanggalPermohonan;
  final String? nomorSuratPengantar;
  final DateTime? tanggalSuratPengantar;
  final String? keteranganPemohon;

  const AdministrasiInfo({
    this.kawasan,
    this.nomorSuratPengantar,
    this.tanggalPermohonan,
    this.tanggalSuratPengantar,
    this.keteranganPemohon,
  });

  AdministrasiInfo copyWith({
    String? kawasan,
    String? nomorSuratPengantar,
    DateTime? tanggalPermohonan,
    DateTime? tanggalSuratPengantar,
    String? keteranganPemohon,
  }) {
    return AdministrasiInfo(
      kawasan: kawasan ?? this.kawasan,
      nomorSuratPengantar: nomorSuratPengantar ?? this.nomorSuratPengantar,
      tanggalPermohonan: tanggalPermohonan ?? this.tanggalPermohonan,
      tanggalSuratPengantar:
          tanggalSuratPengantar ?? this.tanggalSuratPengantar,
      keteranganPemohon: keteranganPemohon ?? this.keteranganPemohon,
    );
  }

  @override
  List<Object?> get props => [
    kawasan,
    nomorSuratPengantar,
    tanggalPermohonan,
    tanggalSuratPengantar,
    keteranganPemohon,
  ];
}

class DataPenanggungJawab extends Equatable {
  final String? namaPenanggungJawab;
  final String? nomorHpPenanggungJawab;
  final String? email;

  const DataPenanggungJawab({
    this.namaPenanggungJawab,
    this.nomorHpPenanggungJawab,
    this.email,
  });

  DataPenanggungJawab copyWith({
    String? namaPenanggungJawab,
    String? nomorHpPenanggungJawab,
    String? email,
  }) {
    return DataPenanggungJawab(
      namaPenanggungJawab: namaPenanggungJawab ?? this.namaPenanggungJawab,
      nomorHpPenanggungJawab:
          nomorHpPenanggungJawab ?? this.nomorHpPenanggungJawab,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
    namaPenanggungJawab,
    nomorHpPenanggungJawab,
    email,
  ];
}

class KegiatanDanTujuan extends Equatable {
  final String? namaKegiatan;
  final String? keperluan;
  final String? tujuanPerjalanan;

  const KegiatanDanTujuan({
    this.namaKegiatan,
    this.keperluan,
    this.tujuanPerjalanan,
  });

  KegiatanDanTujuan copyWith({
    String? namaKegiatan,
    String? keperluan,
    String? tujuanPerjalanan,
  }) {
    return KegiatanDanTujuan(
      namaKegiatan: namaKegiatan ?? this.namaKegiatan,
      keperluan: keperluan ?? this.keperluan,
      tujuanPerjalanan: tujuanPerjalanan ?? this.tujuanPerjalanan,
    );
  }

  @override
  List<Object?> get props => [namaKegiatan, keperluan, tujuanPerjalanan];
}

class WaktuPeminjaman extends Equatable {
  final DateTime? tanggalMulaiPinjam;
  final DateTime? tanggalSelesaiPinjam;

  const WaktuPeminjaman({this.tanggalMulaiPinjam, this.tanggalSelesaiPinjam});

  WaktuPeminjaman copyWith({
    DateTime? tanggalMulaiPinjam,
    DateTime? tanggalSelesaiPinjam,
  }) {
    return WaktuPeminjaman(
      tanggalMulaiPinjam: tanggalMulaiPinjam ?? this.tanggalMulaiPinjam,
      tanggalSelesaiPinjam: tanggalSelesaiPinjam ?? this.tanggalSelesaiPinjam,
    );
  }

  @override
  List<Object?> get props => [tanggalMulaiPinjam, tanggalSelesaiPinjam];
}

class DataPenumpangDanPengemudi extends Equatable {
  final int? jumlahPenumpang;
  final String? statusPengemudi;

  const DataPenumpangDanPengemudi({this.jumlahPenumpang, this.statusPengemudi});

  DataPenumpangDanPengemudi copyWith({int? jumlahPenumpang, String? statusPengemudi}) {
    return DataPenumpangDanPengemudi(
      jumlahPenumpang: jumlahPenumpang ?? this.jumlahPenumpang,
      statusPengemudi: statusPengemudi ?? this.statusPengemudi,
    );
  }

  @override
  List<Object?> get props => [jumlahPenumpang, statusPengemudi];
}

class DokumenPersyaratan extends Equatable {
  final String? suratTugas;

  const DokumenPersyaratan({this.suratTugas});

  DokumenPersyaratan copyWith({String? suratTugas}) {
    return DokumenPersyaratan(suratTugas: suratTugas ?? this.suratTugas);
  }

  @override
  List<Object?> get props => [suratTugas];
}
