import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';

class SewaKendaraanModel extends SewaKendaraan {
  const SewaKendaraanModel({
    required super.dataPemohon,
    required super.administrasiInfo,
    required super.dataPenanggungJawab,
    required super.kegiatanDanTujuan,
    required super.waktuPeminjaman,
    required super.dataPenumpangDanPengemudi,
    required super.dokumenPersyaratan,
  });

  factory SewaKendaraanModel.fromJson(Map<String, dynamic> json) {
    return SewaKendaraanModel(
      dataPemohon: DataPemohonModel.fromJson(
        json['dataPemohon'] as Map<String, dynamic>,
      ),
      administrasiInfo: AdministrasiInfoModel.fromJson(
        json['administrasiInfo'] as Map<String, dynamic>,
      ),
      dataPenanggungJawab: DataPenanggungJawabModel.fromJson(
        json['dataPenanggungJawab'] as Map<String, dynamic>,
      ),
      kegiatanDanTujuan: KegiatanDanTujuanModel.fromJson(
        json['kegiatanDanTujuan'] as Map<String, dynamic>,
      ),
      waktuPeminjaman: WaktuPeminjamanModel.fromJson(
        json['waktuPeminjaman'] as Map<String, dynamic>,
      ),
      dataPenumpangDanPengemudi: DataPenumpangDanPengemudiModel.fromJson(
        json['infoPenumpang'] as Map<String, dynamic>,
      ),
      dokumenPersyaratan: DokumenPersyaratanModel.fromJson(
        json['dokumenPersyaratan'] as Map<String, dynamic>,
      ),
    );
  }
  SewaKendaraan toEntity() {
    return SewaKendaraan(
      dataPemohon: dataPemohon,
      administrasiInfo: administrasiInfo,
      dataPenanggungJawab: dataPenanggungJawab,
      kegiatanDanTujuan: kegiatanDanTujuan,
      waktuPeminjaman: waktuPeminjaman,
      dataPenumpangDanPengemudi: dataPenumpangDanPengemudi,
      dokumenPersyaratan: dokumenPersyaratan,
    );
  }

  Map<String, dynamic> toJson() => {
    'dataPemohon': DataPemohonModel(
      nama: dataPemohon.nama,
      nip: dataPemohon.nip,
      nomorHp: dataPemohon.nomorHp,
      satuanKerja: dataPemohon.satuanKerja,
    ).toJson(),
    'administrasiInfo': AdministrasiInfoModel(
      kawasan: administrasiInfo.kawasan,
      nomorSuratPengantar: administrasiInfo.nomorSuratPengantar,
      tanggalPermohonan: administrasiInfo.tanggalPermohonan,
      tanggalSuratPengantar: administrasiInfo.tanggalSuratPengantar,
      keteranganPemohon: administrasiInfo.keteranganPemohon,
    ).toJson(),
    'penanggungJawab': DataPenanggungJawabModel(
      namaPenanggungJawab: dataPenanggungJawab.namaPenanggungJawab,
      nomorHpPenanggungJawab: dataPenanggungJawab.nomorHpPenanggungJawab,
      email: dataPenanggungJawab.email,
    ).toJson(),
    'kegiatanDanTujuan': KegiatanDanTujuanModel(
      namaKegiatan: kegiatanDanTujuan.namaKegiatan,
      keperluan: kegiatanDanTujuan.keperluan,
      tujuanPerjalanan: kegiatanDanTujuan.tujuanPerjalanan,
    ).toJson(),
    'waktuPeminjaman': WaktuPeminjamanModel(
      tanggalMulaiPinjam: waktuPeminjaman.tanggalMulaiPinjam,
      tanggalSelesaiPinjam: waktuPeminjaman.tanggalSelesaiPinjam,
    ).toJson(),
    'infoPenumpang': DataPenumpangDanPengemudiModel(
      jumlahPenumpang: dataPenumpangDanPengemudi.jumlahPenumpang,
      statusPengemudi: dataPenumpangDanPengemudi.statusPengemudi,
    ).toJson(),
    'dokumenPersyaratan': DokumenPersyaratanModel(
      suratTugas: dokumenPersyaratan.suratTugas,
    ).toJson(),
  };

  SewaKendaraanModel copyWith({
    DataPemohon? dataPemohon,
    AdministrasiInfo? administrasiInfo,
    DataPenanggungJawab? dataPenanggungJawab,
    KegiatanDanTujuan? kegiatanDanTujuan,
    WaktuPeminjaman? waktuPeminjaman,
    DataPenumpangDanPengemudi? dataPenumpangDanPengemudi,
    DokumenPersyaratan? dokumenPersyaratan,
  }) {
    return SewaKendaraanModel(
      dataPemohon: dataPemohon ?? this.dataPemohon,
      administrasiInfo: administrasiInfo ?? this.administrasiInfo,
      dataPenanggungJawab: dataPenanggungJawab ?? this.dataPenanggungJawab,
      kegiatanDanTujuan: kegiatanDanTujuan ?? this.kegiatanDanTujuan,
      waktuPeminjaman: waktuPeminjaman ?? this.waktuPeminjaman,
      dataPenumpangDanPengemudi:
          dataPenumpangDanPengemudi ?? this.dataPenumpangDanPengemudi,
      dokumenPersyaratan: dokumenPersyaratan ?? this.dokumenPersyaratan,
    );
  }
}

class DataPemohonModel extends DataPemohon {
  const DataPemohonModel({
    required super.nama,
    required super.nip,
    required super.nomorHp,
    required super.satuanKerja,
  });

  factory DataPemohonModel.fromJson(Map<String, dynamic> json) {
    return DataPemohonModel(
      nama: json['nama'] as String? ?? '',
      nip: json['nip'] as String? ?? '',
      nomorHp: json['nomorHp'] as String? ?? '',
      satuanKerja: json['satuanKerja'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nip': nip,
    'nomorHp': nomorHp,
    'satuanKerja': satuanKerja,
  };

  DataPemohonModel copyWith({
    String? nama,
    String? nip,
    String? nomorHp,
    String? satuanKerja,
  }) {
    return DataPemohonModel(
      nama: nama ?? this.nama,
      nip: nip ?? this.nip,
      nomorHp: nomorHp ?? this.nomorHp,
      satuanKerja: satuanKerja ?? this.satuanKerja,
    );
  }
}

class AdministrasiInfoModel extends AdministrasiInfo {
  const AdministrasiInfoModel({
    required super.kawasan,
    required super.nomorSuratPengantar,
    required super.tanggalPermohonan,
    required super.tanggalSuratPengantar,
    required super.keteranganPemohon,
  });

  factory AdministrasiInfoModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return null;
    }

    return AdministrasiInfoModel(
      kawasan: json['kawasan'] as String?,
      nomorSuratPengantar: json['nomorSuratPengantar'] as String?,
      tanggalPermohonan: parseDate(json['tanggalPermohonan']),
      tanggalSuratPengantar: parseDate(json['tanggalSuratPengantar']),
      keteranganPemohon: json['keteranganPemohon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'kawasan': kawasan,
    'nomorSuratPengantar': nomorSuratPengantar,
    'tanggalPermohonan': tanggalPermohonan,
    'tanggalSuratPengantar': tanggalSuratPengantar,
    'keteranganPemohon': keteranganPemohon,
  };
}

class DataPenanggungJawabModel extends DataPenanggungJawab {
  const DataPenanggungJawabModel({
    super.namaPenanggungJawab,
    super.nomorHpPenanggungJawab,
    super.email,
  });

  factory DataPenanggungJawabModel.fromJson(Map<String, dynamic> json) {
    return DataPenanggungJawabModel(
      namaPenanggungJawab: json['namaPenanggungJawab'] as String?,
      nomorHpPenanggungJawab: json['nomorHpPenanggungJawab'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'namaPenanggungJawab': namaPenanggungJawab,
    'nomorHpPenanggungJawab': nomorHpPenanggungJawab,
    'email': email,
  };
}

class KegiatanDanTujuanModel extends KegiatanDanTujuan {
  const KegiatanDanTujuanModel({
    super.namaKegiatan,
    super.keperluan,
    super.tujuanPerjalanan,
  });

  factory KegiatanDanTujuanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanDanTujuanModel(
      namaKegiatan: json['namaKegiatan'] as String?,
      keperluan: json['keperluan'] as String?,
      tujuanPerjalanan: json['tujuanPerjalanan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'namaKegiatan': namaKegiatan,
    'keperluan': keperluan,
    'tujuanPerjalanan': tujuanPerjalanan,
  };
}

class WaktuPeminjamanModel extends WaktuPeminjaman {
  const WaktuPeminjamanModel({
    super.tanggalMulaiPinjam,
    super.tanggalSelesaiPinjam,
  });

  factory WaktuPeminjamanModel.fromJson(Map<String, dynamic> json) {
    DateTime? parse(dynamic v) {
      if (v == null) return null;
      if (v is String) return DateTime.tryParse(v);
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return null;
    }

    return WaktuPeminjamanModel(
      tanggalMulaiPinjam: parse(json['tanggalMulaiPinjam']),
      tanggalSelesaiPinjam: parse(json['tanggalSelesaiPinjam']),
    );
  }

  Map<String, dynamic> toJson() => {
    'tanggalMulaiPinjam': tanggalMulaiPinjam,
    'tanggalSelesaiPinjam': tanggalSelesaiPinjam,
  };
}

class DataPenumpangDanPengemudiModel extends DataPenumpangDanPengemudi {
  const DataPenumpangDanPengemudiModel({
    super.jumlahPenumpang,
    super.statusPengemudi,
  });

  factory DataPenumpangDanPengemudiModel.fromJson(Map<String, dynamic> json) {
    final jp = json['jumlahPenumpang'];
    return DataPenumpangDanPengemudiModel(
      jumlahPenumpang: jp is int
          ? jp
          : (jp is String ? int.tryParse(jp) : null),
      statusPengemudi: json['statusPengemudi'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'jumlahPenumpang': jumlahPenumpang,
    'statusPengemudi': statusPengemudi,
  };
}

class DokumenPersyaratanModel extends DokumenPersyaratan {
  const DokumenPersyaratanModel({super.suratTugas});

  factory DokumenPersyaratanModel.fromJson(Map<String, dynamic> json) {
    return DokumenPersyaratanModel(suratTugas: json['suratTugas'] as String?);
  }

  Map<String, dynamic> toJson() => {'suratTugas': suratTugas};
}
