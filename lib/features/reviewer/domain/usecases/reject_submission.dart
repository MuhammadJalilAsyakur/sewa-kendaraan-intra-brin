import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class RejectSubmission {
  final ReviewerRepository repository;

  RejectSubmission(this.repository);

  Future<void> call(String id, String alasan) async {
    return await repository.rejectSubmission(id, alasan);
  }
}
