import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/core/shared/submission_store.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/tracking_item.dart';
import 'package:vehicle_rental/features/civitas/domain/repositories/tracking_repository.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';

enum TrackingFilter { all, pending, approved, rejected }

class TrackingController extends GetxController {
  final TrackingRepository repository;

  TrackingController({required this.repository});

  final _trackingItems = <TrackingItem>[].obs;
  List<TrackingItem> get trackingItems => _trackingItems;

  final _selectedItem = Rxn<TrackingItem>();
  TrackingItem? get selectedItem => _selectedItem.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  TrackingItem? getById(String id) {
    try {
      return _trackingItems.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  String _formatRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return "-";
    return "${DateFormat('dd/MM/yyyy HH:mm').format(start)} S/D ${DateFormat('dd/MM/yyyy HH:mm').format(end)}";
  }

  final _error = Rxn<String>();
  String? get error => _error.value;

  final _currentFilter = TrackingFilter.all.obs;
  TrackingFilter get currentFilter => _currentFilter.value;

  List<TrackingItem> get filteredItems {
    switch (_currentFilter.value) {
      case TrackingFilter.pending:
        return _trackingItems
            .where((item) => item.status == 'Menunggu Persetujuan')
            .toList();
      case TrackingFilter.approved:
        return _trackingItems
            .where((item) => item.status == 'Disetujui')
            .toList();
      case TrackingFilter.rejected:
        return _trackingItems
            .where((item) => item.status == 'Ditolak')
            .toList();
      case TrackingFilter.all:
      default:
        return _trackingItems.toList();
    }
  }

  Future<bool> createTrackingFromData({
    required String id,
    required String status,
    required DateTime tanggalPengajuan,
    required String judul,
    required String keperluan,
    required String periode,
    required SewaKendaraan detailData,
  }) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final trackingItem = TrackingItem(
        id: id,
        status: status,
        tanggalPengajuan: tanggalPengajuan,
        judul: judul,
        keperluan: keperluan,
        periode: periode,
        detailData: detailData,
      );

      _trackingItems.insert(0, trackingItem);

      print("✅ Tracking item created: ${trackingItem.id}");
      return true;
    } catch (e) {
      _error.value = e.toString();
      print("❌ Error creating tracking: $e");
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  void updateTrackingItem(String id, SewaKendaraan newData) {
    final index = _trackingItems.indexWhere((e) => e.id == id);
    if (index == -1) return;

    _trackingItems[index] = _trackingItems[index].copyWith(
      detailData: newData,
      keperluan: newData.kegiatanDanTujuan.keperluan ?? '-',
      periode: _formatRange(
        newData.waktuPeminjaman.tanggalMulaiPinjam,
        newData.waktuPeminjaman.tanggalSelesaiPinjam,
      ),
    );
  }

  Future<void> loadTrackingList() async {
    _isLoading.value = true;

    try {
      final items = await repository.getTrackingList();

      if (_trackingItems.isEmpty) {
        _trackingItems.assignAll(items);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadTrackingDetail(String id) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final localItem = _trackingItems.firstWhere(
        (e) => e.id == id,
        orElse: () => throw Exception('Tracking item not found'),
      );
      _selectedItem.value = localItem;
      print("✅ Loaded detail from local for ID: $id");
    } catch (e) {
      try {
        _selectedItem.value = await repository.getTrackingDetail(id);
      } catch (e) {
        _error.value = e.toString();
        print('❌ Error loading detail: $e');
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<bool> cancelSubmission(String id) async {
    try {
      await repository.cancelSubmission(id);

      _trackingItems.removeWhere((item) => item.id == id);

      if (_selectedItem.value?.id == id) {
        _selectedItem.value = null;
      }

      SubmissionStore().removeSubmission(id);

      // Refresh reviewer list so cancelled item disappears there too
      if (Get.isRegistered<ReviewerController>()) {
        Get.find<ReviewerController>().loadReviewerList();
      }

      print("✅ Cancelled submission ID: $id");
      return true;
    } catch (e) {
      _error.value = e.toString();
      print("❌ Error canceling submission: $e");
      return false;
    }
  }

  Future<String?> downloadPdf(String id) async {
    try {
      final path = await repository.downloadPdf(id);
      print("✅ PDF downloaded to: $path");
      return path;
    } catch (e) {
      _error.value = e.toString();
      print('❌ Error downloading PDF: $e');
      return null;
    }
  }

  void setFilter(TrackingFilter filter) {
    _currentFilter.value = filter;
  }

  int getPendingCount() => _trackingItems
      .where((item) => item.status == 'Menunggu Persetujuan')
      .length;

  int getApprovedCount() =>
      _trackingItems.where((item) => item.status == 'Disetujui').length;

  int getRejectedCount() =>
      _trackingItems.where((item) => item.status == 'Ditolak').length;

  void clearError() {
    _error.value = null;
  }

  Future<void> refresh() async {
    await loadTrackingList();
  }
}
