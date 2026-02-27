import 'package:flutter/material.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_list.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_by_status.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/approve_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/reject_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/download_pdf.dart';

class ReviewerProvider extends ChangeNotifier {
  final GetReviewerList getReviewerList;
  final GetReviewerByStatus getReviewerByStatus;
  final ApproveSubmission approveSubmission;
  final RejectSubmission rejectSubmission;
  final DownloadPdf downloadPdf;

  ReviewerProvider({
    required this.getReviewerList,
    required this.getReviewerByStatus,
    required this.approveSubmission,
    required this.rejectSubmission,
    required this.downloadPdf,
  }) {
    loadReviewerList();
  }

  List<ReviewerItem> _reviewerList = [];
  bool _isLoading = false;
  String? _error;
  String _selectedStatus = 'Semua Status';
  String _selectedWaktu = 'Semua Waktu';

  List<ReviewerItem> get reviewerList => _reviewerList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedStatus => _selectedStatus;
  String get selectedWaktu => _selectedWaktu;

  List<ReviewerItem> get filteredList {
    return _reviewerList.where((item) {
      final statusMatch =
          _selectedStatus == 'Semua Status' || item.status == _selectedStatus;
      return statusMatch;
    }).toList();
  }

  Future<void> loadReviewerList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _reviewerList = await getReviewerList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterByStatus(String status) async {
    _selectedStatus = status;
    notifyListeners();
  }

  void setSelectedWaktu(String waktu) {
    _selectedWaktu = waktu;
    notifyListeners();
  }

  Future<bool> approve(String id) async {
    try {
      await approveSubmission(id);
      await loadReviewerList();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> reject(String id, String alasan) async {
    try {
      await rejectSubmission(id, alasan);
      await loadReviewerList();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<String?> getPdf(String id) async {
    try {
      return await downloadPdf(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
