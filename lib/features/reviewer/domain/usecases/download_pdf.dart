import 'package:vehicle_rental/features/reviewer/domain/repositories/reviewer_repository.dart';

class DownloadPdf {
  final ReviewerRepository repository;

  DownloadPdf(this.repository);

  Future<String> call(String id) async {
    return await repository.downloadPdf(id);
  }
}
