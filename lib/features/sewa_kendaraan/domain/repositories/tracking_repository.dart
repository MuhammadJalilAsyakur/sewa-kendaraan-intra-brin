import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/tracking_item.dart';

abstract class TrackingRepository {
  Future<List<TrackingItem>> getTrackingList();
  Future<TrackingItem> getTrackingDetail(String id);
  Future<List<TrackingItem>> getTrackingByStatus(String status);
  Future<void> cancelSubmission(String id);
  Future<String> downloadPdf(String id);

  Future<TrackingItem> createTrackingFromData({
    required String id,
    required String status,
    required DateTime tanggalPengajuan,
    required String judul,
    required String keperluan,
    required String periode,
  });
}
