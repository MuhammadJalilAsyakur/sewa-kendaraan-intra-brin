import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class ApproveSubmission {
  final ReviewerRepository repository;

  ApproveSubmission(this.repository);

  Future<void> call(String id) async {
    return await repository.approveSubmission(id);
  }
}