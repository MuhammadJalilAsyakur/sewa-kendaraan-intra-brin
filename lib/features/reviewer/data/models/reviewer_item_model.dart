import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';

class ReviewerItemModel extends ReviewerItem {
  const ReviewerItemModel({
    required super.id,
    required super.status,
    required super.tanggalPengajuan,
    required super.judul,
    required super.namaPemohon,
    required super.satuanKerja,
    required super.keperluan,
    required super.periode,
    required super.showApprove,
    required super.showReject,
    required super.showDetail,
    required super.showPdf,
  });

  factory ReviewerItemModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'] ?? 'Menunggu Persetujuan';
    return ReviewerItemModel(
      id: json['id'].toString(),
      status: status,
      tanggalPengajuan: DateTime.parse(json['tgl_permohonan']),
      judul: json['judul'] ?? 'Permohonan Peminjaman Kendaraan',
      namaPemohon: json['nm_pemohon'] ?? '',
      satuanKerja: json['unit_name'] ?? '',
      keperluan: json['keperluan'] ?? '',
      periode: json['periode'] ?? '',
      showApprove: status == 'Menunggu Persetujuan',
      showReject: status == 'Menunggu Persetujuan',
      showDetail: true,
      showPdf: status == 'Disetujui',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'tgl_permohonan': tanggalPengajuan.toIso8601String(),
      'judul': judul,
      'nm_pemohon': namaPemohon,
      'unit_name': satuanKerja,
      'keperluan': keperluan,
      'periode': periode,
    };
  }

  ReviewerItem toEntity() {
    return ReviewerItem(
      id: id,
      status: status,
      tanggalPengajuan: tanggalPengajuan,
      judul: judul,
      namaPemohon: namaPemohon,
      satuanKerja: satuanKerja,
      keperluan: keperluan,
      periode: periode,
      showApprove: showApprove,
      showReject: showReject,
      showDetail: showDetail,
      showPdf: showPdf,
    );
  }
}
