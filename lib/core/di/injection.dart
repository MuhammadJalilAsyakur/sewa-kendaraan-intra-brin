import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vehicle_rental/core/constants/api_constanst.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/datasources/sewa_kendaraan_remote_datasource.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/repositories/sewa_kendaraan_repositori_impl.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/repositories/sewa_kendaraan_repository.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/providers/sewa_kendaraan_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  )));

  // Datasource
  sl.registerLazySingleton<SewaKendaraanDataSourceImpl>(
    () => SewaKendaraanDataSourceImpl(dio: sl()),
  );

  // Repository
  sl.registerLazySingleton<SewaKendaraanRepository>(
    () => SewaKendaraanRepositoriImpl(remoteDataSource: sl()),
  );

  // Provider
  sl.registerFactory(
    () => SewaKendaraanProvider(repository: sl()),
  );
}