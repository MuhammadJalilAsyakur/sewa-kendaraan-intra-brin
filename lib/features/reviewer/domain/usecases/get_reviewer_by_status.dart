import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class GetReviewerByStatus {
  final ReviewerRepository repository;

  GetReviewerByStatus(this.repository);

  Future<List<ReviewerItem>> call(String status) async {
    return await repository.getReviewerByStatus(status);
  }
}
