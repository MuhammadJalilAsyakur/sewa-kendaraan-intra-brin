import 'package:vehicle_rental/features/reviewer/data/datasources/reviewer_remote_datasource.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class ReviewerRepositoryImpl implements ReviewerRepository {
  final ReviewerRemoteDatasource remoteDatasource;

  ReviewerRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ReviewerItem>> getReviewerList() async {
    try {
      final models = await remoteDatasource.getReviewerList();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get reviewer list - $e');
    }
  }

  @override
  Future<ReviewerItem> getReviewerDetail(String id) async {
    try {
      final model = await remoteDatasource.getReviewerDetail(id);
      return model.toEntity();
    } catch (e) {
      throw Exception('Repository: Failed to get reviewer detail - $e');
    }
  }

  @override
  Future<List<ReviewerItem>> getReviewerByStatus(String status) async {
    try {
      final models = await remoteDatasource.getReviewerByStatus(status);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception('Repository: Failed to get reviewer by status - $e');
    }
  }

  @override
  Future<void> approveSubmission(String id) async {
    try {
      await remoteDatasource.approveSubmission(id);
    } catch (e) {
      throw Exception('Repository: Failed to approve submission - $e');
    }
  }

  @override
  Future<void> rejectSubmission(String id, String alasan) async {
    try {
      await remoteDatasource.rejectSubmission(id, alasan);
    } catch (e) {
      throw Exception('Repository: Failed to reject submission - $e');
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
}
