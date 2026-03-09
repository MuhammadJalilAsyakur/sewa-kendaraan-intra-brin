import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:vehicle_rental/core/constants/api_constanst.dart';
import 'package:vehicle_rental/features/civitas/data/datasources/sewa_kendaraan_remote_datasource.dart';
import 'package:vehicle_rental/features/civitas/data/datasources/tracking_remote_datasource.dart';
import 'package:vehicle_rental/features/civitas/data/repositories/sewa_kendaraan_repositori_impl.dart';
import 'package:vehicle_rental/features/civitas/data/repositories/tracking_repositori_impl.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';
import 'package:vehicle_rental/features/reviewer/data/datasources/reviewer_remote_datasource.dart';
import 'package:vehicle_rental/features/reviewer/data/repositories/reviewer_repository_impl.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/approve_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/download_pdf.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_by_status.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_list.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/reject_submission.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Dio
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Datasources
    final sewaKendaraanDataSource = SewaKendaraanDataSourceImpl(dio: dio);
    final trackingDataSource = TrackingRemoteDatasourceImpl();
    final reviewerDatasource = ReviewerRemoteDatasourceImpl(dio: dio);

    // Repositories
    final sewaKendaraanRepository = SewaKendaraanRepositoriImpl(
      remoteDataSource: sewaKendaraanDataSource,
    );
    final trackingRepository = TrackingRepositoryImpl(
      remoteDatasource: trackingDataSource,
    );
    final reviewerRepository = ReviewerRepositoryImpl(
      remoteDatasource: reviewerDatasource,
    );

    // Controllers
    Get.lazyPut<SewaKendaraanController>(
      () => SewaKendaraanController(repository: sewaKendaraanRepository),
      fenix: true,
    );

    Get.lazyPut<TrackingController>(
      () => TrackingController(repository: trackingRepository),
      fenix: true,
    );

    Get.lazyPut<ReviewerController>(
      () => ReviewerController(
        getReviewerList: GetReviewerList(reviewerRepository),
        getReviewerByStatus: GetReviewerByStatus(reviewerRepository),
        approveSubmission: ApproveSubmission(reviewerRepository),
        rejectSubmission: RejectSubmission(reviewerRepository),
        downloadPdf: DownloadPdf(reviewerRepository),
      ),
      fenix: true,
    );
  }
}
