// domain/usecases/watch_rental_status.dart
import 'package:vehicle_rental/features/sewa_kendaraan/data/repositories/sewa_kendaraan_repositori_impl.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/domain/entities/sewa_kendaraan.dart';

class WatchRentalStatus {
  final SewaKendaraanRepositoriImpl repository;

  WatchRentalStatus(this.repository);

  Stream<SewaKendaraan?> execute() {
    return repository.watchStatus();
  }
}