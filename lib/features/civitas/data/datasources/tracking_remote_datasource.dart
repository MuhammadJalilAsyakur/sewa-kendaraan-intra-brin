import 'package:vehicle_rental/features/civitas/data/models/tracking_item_model.dart';

abstract class TrackingRemoteDatasource {
  Future<List<TrackingItemModel>> getTrackingList();
  Future<TrackingItemModel> getTrackingDetail(String id);
  Future<List<TrackingItemModel>> getTrackingByStatus(String status);
  Future<void> cancelSubmission(String id);
  Future<String> downloadPdf(String id);

  Future<TrackingItemModel> createTrackingFromData({
    required String id,
    required String status,
    required DateTime tanggalPengajuan,
    required String judul,
    required String keperluan,
    required String periode,
  });
}

class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  final List<TrackingItemModel> _localDatabase = [];

  TrackingRemoteDatasourceImpl();

  @override
  Future<List<TrackingItemModel>> getTrackingList() async {
    await Future.delayed(const Duration(milliseconds: 500));

    print('📦 Local DB: ${_localDatabase.length} items');
    return List.from(_localDatabase);
  }

  @override
  Future<TrackingItemModel> getTrackingDetail(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final item = _localDatabase.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Tracking item not found'),
    );

    return item;
  }

  @override
  Future<List<TrackingItemModel>> getTrackingByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _localDatabase
        .where((item) => item.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  @override
  Future<void> cancelSubmission(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _localDatabase.removeWhere((item) => item.id == id);
    print('🗑️ Deleted item: $id');
  }

  @override
  Future<String> downloadPdf(String id) async {
    await Future.delayed(const Duration(seconds: 2));

    final item = _localDatabase.firstWhere(
      (item) => item.id == id,
      orElse: () => throw Exception('Tracking item not found'),
    );

    final pdfPath = '/storage/emulated/0/Download/${item.judul}.pdf';
    print('📄 PDF downloaded: $pdfPath');

    return pdfPath;
  }

  @override
  Future<TrackingItemModel> createTrackingFromData({
    required String id,
    required String status,
    required DateTime tanggalPengajuan,
    required String judul,
    required String keperluan,
    required String periode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newItem = TrackingItemModel(
      id: id,
      status: status,
      tanggalPengajuan: tanggalPengajuan,
      judul: judul,
      keperluan: keperluan,
      periode: periode,
      showEdit: status == 'Menunggu Persetujuan',
      showCancel: status == 'Menunggu Persetujuan',
      showPdf: status == 'Disetujui',
      showDetail: true,
    );

    _localDatabase.insert(0, newItem); 
    print('✅ Created tracking item: $id');

    return newItem;
  }

  void clearAll() {
    _localDatabase.clear();
    print('🗑️ Cleared all tracking items');
  }
}
