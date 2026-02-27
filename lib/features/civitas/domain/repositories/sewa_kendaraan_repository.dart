import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';

abstract class SewaKendaraanRepository {
  Future<DataPemohon> getDataPemohon();
  Future<void> submitSewaKendaraan(SewaKendaraan request);
  Stream<SewaKendaraan?> watchStatus();
  Future<List<SewaKendaraan>> getHistory();
  Future<void> updateSewaKendaraan({
    required String id,
    required SewaKendaraan data,
  });
}
