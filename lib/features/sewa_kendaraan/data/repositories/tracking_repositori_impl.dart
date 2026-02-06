import 'package:vehicle_rental/features/sewa_kendaraan/data/datasources/tracking_remode_datasource.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/tracking_item.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDatasource remoteDatasource;

  TrackingRepositoryImpl({required this.remoteDatasource});

  @override
  Future<void> cancelSubmission(String id) async {
    try {
      await remoteDatasource.cancelSubmission(id);
    } catch (e) {
      throw Exception('Repository: Failed to cancel submission - $e');
    }
  }

  @override
  Future<String> downloadPdf(String id) async {
    try {
      return await remoteDatasource.downloadPdf(id);
    } catch (e) {
      throw Exception('Repository: Failed to download PDF - $e');
    }
  }

  @override
  Future<List<TrackingItem>> getTrackingByStatus(String status) async {
    try {
      final models = await remoteDatasource.getTrackingByStatus(status);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get tracking by status - $e');
    }
  }

  @override
  Future<TrackingItem> getTrackingDetail(String id) async {
    try {
      final model = await remoteDatasource.getTrackingDetail(id);
      return model.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get tracking detail - $e');
    }
  }

  @override
  Future<List<TrackingItem>> getTrackingList() async {
    try {
      final models = await remoteDatasource.getTrackingList();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get tracking list - $e');
    }
  }

  @override
  Future<TrackingItem> createTrackingFromData({
    required String id,
    required String status,
    required DateTime tanggalPengajuan,
    required String judul,
    required String keperluan,
    required String periode,
  }) async {
    try {
      final model = await remoteDatasource.createTrackingFromData(
        id: id,
        status: status,
        tanggalPengajuan: tanggalPengajuan,
        judul: judul,
        keperluan: keperluan,
        periode: periode,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to create tracking - $e');
    }
  }
}
