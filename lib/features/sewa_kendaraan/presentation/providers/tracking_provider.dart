import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/tracking_item.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/repositories/tracking_repository.dart';

enum TrackingFilter { all, pending, approved, rejected }

class TrackingProvider extends ChangeNotifier {
  final TrackingRepository repository;

  TrackingProvider({required this.repository});

  List<TrackingItem> _trackingItems = [];
  List<TrackingItem> get trackingItems => _trackingItems;

  TrackingItem? _selectedItem;
  TrackingItem? get selectedItem => _selectedItem;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
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

  String? _error;
  String? get error => _error;

  TrackingFilter _currentFilter = TrackingFilter.all;
  TrackingFilter get currentFilter => _currentFilter;

  List<TrackingItem> get filteredItems {
    switch (_currentFilter) {
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
        return _trackingItems;
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
    _isLoading = true;
    _error = null;
    notifyListeners();

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

      // Insert di awal list
      _trackingItems.insert(0, trackingItem);

      print("✅ Tracking item created: ${trackingItem.id}");
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      print("❌ Error creating tracking: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
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

    notifyListeners();
  }

  Future<void> loadTrackingList() async {
    _isLoading = true;
    notifyListeners();

    try {
      final items = await repository.getTrackingList();

      if (_trackingItems.isEmpty) {
        _trackingItems = items;
      }
      // kalau sudah ada → JANGAN TIMPA
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrackingDetail(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedItem = await repository.getTrackingDetail(id);
      print("✅ Loaded detail for ID: $id");
    } catch (e) {
      _error = e.toString();
      print('❌ Error loading detail: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cancelSubmission(String id) async {
    try {
      await repository.cancelSubmission(id);

      _trackingItems.removeWhere((item) => item.id == id);

      if (_selectedItem?.id == id) {
        _selectedItem = null;
      }

      notifyListeners();
      print("✅ Cancelled submission ID: $id");
      return true;
    } catch (e) {
      _error = e.toString();
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
      _error = e.toString();
      print('❌ Error downloading PDF: $e');
      return null;
    }
  }

  void setFilter(TrackingFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  int getPendingCount() => _trackingItems
      .where((item) => item.status == 'Menunggu Persetujuan')
      .length;

  int getApprovedCount() =>
      _trackingItems.where((item) => item.status == 'Disetujui').length;

  int getRejectedCount() =>
      _trackingItems.where((item) => item.status == 'Ditolak').length;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadTrackingList();
  }
}
