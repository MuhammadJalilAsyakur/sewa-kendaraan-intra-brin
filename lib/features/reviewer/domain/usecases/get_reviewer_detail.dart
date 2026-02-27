import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class GetReviewerDetail {
  final ReviewerRepository repository;

  GetReviewerDetail(this.repository);

  Future<ReviewerItem> call(String id) async {
    return await repository.getReviewerDetail(id);
  }
}