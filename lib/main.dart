import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/core/constants/api_constanst.dart';
import 'package:vehicle_rental/features/reviewer/data/datasources/reviewer_remote_datasource.dart';
import 'package:vehicle_rental/features/reviewer/data/repositories/reviewer_repository_impl.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/approve_submission.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/download_pdf.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_by_status.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/get_reviewer_list.dart';
import 'package:vehicle_rental/features/reviewer/domain/usecases/reject_submission.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';
import 'package:vehicle_rental/features/civitas/data/datasources/sewa_kendaraan_remote_datasource.dart';
import 'package:vehicle_rental/features/civitas/data/datasources/tracking_remote_datasource.dart';
import 'package:vehicle_rental/features/civitas/data/repositories/sewa_kendaraan_repositori_impl.dart';
import 'package:vehicle_rental/features/civitas/data/repositories/tracking_repositori_impl.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/welcome_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

  final sewaKendaraanDataSource = SewaKendaraanDataSourceImpl(dio: dio);
  final trackingDataSource = TrackingRemoteDatasourceImpl();
  final reviewerDatasource = ReviewerRemoteDatasourceImpl(dio: dio);

  final trackingRepository = TrackingRepositoryImpl(
    remoteDatasource: trackingDataSource,
  );
  final sewaKendaraanRepository = SewaKendaraanRepositoriImpl(
    remoteDataSource: sewaKendaraanDataSource,
  );
  final reviewerRepository = ReviewerRepositoryImpl(
    remoteDatasource: reviewerDatasource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              SewaKendaraanProvider(repository: sewaKendaraanRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TrackingProvider(repository: trackingRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ReviewerProvider(
            getReviewerList: GetReviewerList(reviewerRepository),
            getReviewerByStatus: GetReviewerByStatus(reviewerRepository),
            approveSubmission: ApproveSubmission(reviewerRepository),
            rejectSubmission: RejectSubmission(reviewerRepository),
            downloadPdf: DownloadPdf(reviewerRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ).copyWith(surfaceTint: Colors.transparent),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomePage(),
    );
  }
}
