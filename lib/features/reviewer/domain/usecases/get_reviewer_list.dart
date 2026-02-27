import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class GetReviewerList {
  final ReviewerRepository repository;

  GetReviewerList(this.repository);

  Future<List<ReviewerItem>> call() async {
    return await repository.getReviewerList();
  }
}
