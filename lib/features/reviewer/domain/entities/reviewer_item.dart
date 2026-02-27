import 'package:equatable/equatable.dart';

class ReviewerItem extends Equatable {
  final String id;
  final String status;
  final DateTime tanggalPengajuan;
  final String judul;
  final String namaPemohon;
  final String satuanKerja;
  final String keperluan;
  final String periode;
  final bool showApprove;
  final bool showReject;
  final bool showDetail;
  final bool showPdf;

  const ReviewerItem({
    required this.id,
    required this.status,
    required this.tanggalPengajuan,
    required this.judul,
    required this.namaPemohon,
    required this.satuanKerja,
    required this.keperluan,
    required this.periode,
    required this.showApprove,
    required this.showReject,
    required this.showDetail,
    required this.showPdf,
  });

  @override
  List<Object?> get props => [
    id,
    status,
    tanggalPengajuan,
    judul,
    namaPemohon,
    satuanKerja,
    keperluan,
    periode,
    showApprove,
    showReject,
    showDetail,
    showPdf,
  ];
}