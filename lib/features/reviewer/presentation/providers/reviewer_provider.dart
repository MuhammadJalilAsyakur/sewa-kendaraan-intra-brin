import 'package:get/get.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_list.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_by_status.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/approve_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/reject_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/download_pdf.dart';

class ReviewerController extends GetxController {
  final GetReviewerList getReviewerList;
  final GetReviewerByStatus getReviewerByStatus;
  final ApproveSubmission approveSubmission;
  final RejectSubmission rejectSubmission;
  final DownloadPdf downloadPdf;

  ReviewerController({
    required this.getReviewerList,
    required this.getReviewerByStatus,
    required this.approveSubmission,
    required this.rejectSubmission,
    required this.downloadPdf,
  });

  @override
  void onInit() {
    super.onInit();
    loadReviewerList();
  }

  final _reviewerList = <ReviewerItem>[].obs;
  final _isLoading = false.obs;
  final _error = Rxn<String>();
  final _selectedStatus = 'Semua Status'.obs;
  final _selectedWaktu = 'Semua Waktu'.obs;

  List<ReviewerItem> get reviewerList => _reviewerList;
  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  String get selectedStatus => _selectedStatus.value;
  String get selectedWaktu => _selectedWaktu.value;

  List<ReviewerItem> get filteredList {
    return _reviewerList.where((item) {
      final statusMatch =
          _selectedStatus.value == 'Semua Status' ||
          item.status == _selectedStatus.value;
      return statusMatch;
    }).toList();
  }

  Future<void> loadReviewerList() async {
    _isLoading.value = true;
    _error.value = null;
    try {
      _reviewerList.assignAll(await getReviewerList());
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> filterByStatus(String status) async {
    _selectedStatus.value = status;
  }

  void setSelectedWaktu(String waktu) {
    _selectedWaktu.value = waktu;
  }

  Future<bool> approve(String id) async {
    try {
      await approveSubmission(id);
      await loadReviewerList();
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    }
  }

  Future<bool> reject(String id, String alasan) async {
    try {
      await rejectSubmission(id, alasan);
      await loadReviewerList();
      return true;
    } catch (e) {
      _error.value = e.toString();
      return false;
    }
  }

  Future<String?> getPdf(String id) async {
    try {
      return await downloadPdf(id);
    } catch (e) {
      _error.value = e.toString();
      return null;
    }
  }
}
