import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/datasources/sewa_kendaraan_remote_datasource.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/datasources/tracking_remode_datasource.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/repositories/sewa_kendaraan_repositori_impl.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/repositories/tracking_repositori_impl.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/pages/welcome_page.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/providers/tracking_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final sewaKendaraanDataSource = SewaKendaraanDataSourceImpl();
  final trackingDataSource = TrackingRemoteDatasourceImpl();

  final trackingRepository = TrackingRepositoryImpl(
    remoteDatasource: trackingDataSource,
  );
  final sewaKendaraanRepository = SewaKendaraanRepositoriImpl(
    remoteDataSource: sewaKendaraanDataSource,
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
