
import 'package:vehicle_rental/features/civitas/domain/entities/tracking_item.dart';

class TrackingItemModel extends TrackingItem {
  TrackingItemModel({
    required super.id,
    required super.status,
    required super.tanggalPengajuan,
    required super.judul,
    required super.keperluan,
    required super.periode,
    super.showEdit,
    super.showCancel,
    super.showDetail,
    super.showPdf,
  });

  factory TrackingItemModel.fromJson(Map<String, dynamic> json) {
    return TrackingItemModel(
      id: json['id'] as String,
      status: json['status'] as String,
      tanggalPengajuan: DateTime.parse(json['tanggalPengajuan'] as String),
      judul: json['judul'] as String,
      keperluan: json['keperluan'] as String,
      periode: json['periode'] as String,
      showEdit: json['show_edit'] as bool? ?? false,
      showCancel: json['show_cancel'] as bool? ?? false,
      showPdf: json['show_pdf'] as bool? ?? false,
      showDetail: json['show_detail'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'tanggal_pengajuan': tanggalPengajuan.toIso8601String(),
      'judul': judul,
      'keperluan': keperluan,
      'periode': periode,
      'show_edit': showEdit,
      'show_cancel': showCancel,
      'show_pdf': showPdf,
      'show_detail': showDetail,
    };
  }

  TrackingItem toEntity() => TrackingItem(
    id: id,
    status: status,
    tanggalPengajuan: tanggalPengajuan,
    judul: judul,
    keperluan: keperluan,
    periode: periode,
    showEdit: showEdit,
    showCancel: showCancel,
    showDetail: showDetail,
    showPdf: showPdf,
  );

  factory TrackingItemModel.fromEntity(TrackingItem entity) {
    return TrackingItemModel(
      id: entity.id,
      status: entity.status,
      tanggalPengajuan: entity.tanggalPengajuan,
      judul: entity.judul,
      keperluan: entity.keperluan,
      periode: entity.periode,
      showEdit: entity.showEdit,
      showCancel: entity.showCancel,
      showDetail: entity.showDetail,
      showPdf: entity.showEdit,
    );
  }
}
