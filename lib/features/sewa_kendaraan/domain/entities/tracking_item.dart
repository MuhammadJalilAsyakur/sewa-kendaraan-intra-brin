import 'package:flutter/widgets.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';

class TrackingItem {
  final String id;
  final String status;
  final DateTime tanggalPengajuan;
  final String judul;
  final String keperluan;
  final String periode;
  final bool showEdit;
  final bool showCancel;
  final bool showPdf;
  final bool showDetail;
  final SewaKendaraan? detailData;

  const TrackingItem({
    required this.id,
    required this.status,
    required this.tanggalPengajuan,
    required this.judul,
    required this.keperluan,
    required this.periode,
    this.showEdit = false,
    this.showCancel = false,
    this.showPdf = false,
    this.showDetail = true,
    this.detailData,
  });
  TrackingItem copyWith({
    String? id,
    String? status,
    DateTime? tanggalPengajuan,
    String? judul,
    String? keperluan,
    String? periode,
    SewaKendaraan? detailData,
  }) {
    return TrackingItem(
      id: id ?? this.id,
      status: status ?? this.status,
      tanggalPengajuan: tanggalPengajuan ?? this.tanggalPengajuan,
      judul: judul ?? this.judul,
      keperluan: keperluan ?? this.keperluan,
      periode: periode ?? this.periode,
      detailData: detailData ?? this.detailData,
    );
  }

  bool get canEdit => status == 'Menunggu Persetujuan';
  bool get canCancel => status == 'Menunggu Persetujuan';
  bool get canViewPdf => status == 'Disetujui';
  bool get canViewDetail => status == 'Disetujui' || status == 'Ditolak';

  int get statusColorValue {
    if (status == "Menunggu Persetujuan") return 0xFF9F43;
    if (status == "Disetujui") return 0x28C76F;
    if (status == "Ditolak") return 0xFF4C51;
    return 0xFF9E9E9E;
  }

  String get statusText => status;

  Color get statusColor => Color(statusColorValue);
}
