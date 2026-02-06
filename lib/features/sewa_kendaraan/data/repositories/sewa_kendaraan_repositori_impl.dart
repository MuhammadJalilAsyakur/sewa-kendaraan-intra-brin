import 'package:vehicle_rental/features/sewa_kendaraan/data/datasources/sewa_kendaraan_remote_datasource.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/data/models/sewa_kendaraan_model.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/repositories/sewa_kendaraan_repository.dart';

class SewaKendaraanRepositoriImpl implements SewaKendaraanRepository {
  final SewaKendaraanDataSourceImpl remoteDataSource;

  SewaKendaraanRepositoriImpl({required this.remoteDataSource});

  @override
  Future<DataPemohon> getDataPemohon() async {
    return await remoteDataSource.getDataPemohon();
  }

  @override
  Future<void> submitSewaKendaraan(SewaKendaraan request) async {
    final model = SewaKendaraanModel(
      dataPemohon: request.dataPemohon,
      administrasiInfo: request.administrasiInfo,
      dataPenanggungJawab: request.dataPenanggungJawab,
      kegiatanDanTujuan: request.kegiatanDanTujuan,
      waktuPeminjaman: request.waktuPeminjaman,
      dataPenumpangDanPengemudi: request.dataPenumpangDanPengemudi,
      dokumenPersyaratan: request.dokumenPersyaratan,
    );

    await remoteDataSource.submitSewaKendaraan(model);
  }

  @override
  Stream<SewaKendaraan?> watchStatus() {
    return remoteDataSource.watchLatestSubmission().map((model) {
      if (model == null) return null;
      return model.toEntity();
    });
  }

  @override
  Future<List<SewaKendaraan>> getHistory() async {
    final models = await remoteDataSource.getHistory();

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateSewaKendaraan({
    required String id,
    required SewaKendaraan data,
  }) {
    return remoteDataSource.updateSewaKendaraan(id, data);
  }
}
