import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';

abstract class ReviewerRepository {
  Future<List<ReviewerItem>> getReviewerList();
  Future<ReviewerItem> getReviewerDetail(String id);
  Future<List<ReviewerItem>> getReviewerByStatus(String status);
  Future<void> approveSubmission(String id);
  Future<void> rejectSubmission(String id, String alasan);
  Future<String> downloadPdf(String id);
}
