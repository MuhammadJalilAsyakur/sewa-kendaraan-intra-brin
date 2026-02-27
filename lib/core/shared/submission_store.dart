import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:intl/intl.dart';

class SubmissionStore {
  static final SubmissionStore _instance = SubmissionStore._internal();
  factory SubmissionStore() => _instance;
  SubmissionStore._internal();

  final List<ReviewerItem> _submissions = [];

  List<ReviewerItem> get submissions => List.from(_submissions);

  void addSubmission({
    required String id,
    required String namaPemohon,
    required String satuanKerja,
    required String keperluan,
    required DateTime tanggalMulaiPinjam,
    required DateTime tanggalSelesaiPinjam,
  }) {
    final periode =
        '${DateFormat('dd/MM/yyyy HH:mm').format(tanggalMulaiPinjam)} S/D ${DateFormat('dd/MM/yyyy HH:mm').format(tanggalSelesaiPinjam)}';

    _submissions.insert(
      0,
      ReviewerItem(
        id: id,
        status: 'Menunggu Persetujuan',
        tanggalPengajuan: DateTime.now(),
        judul: 'Permohonan Peminjaman Kendaraan',
        namaPemohon: namaPemohon,
        satuanKerja: satuanKerja,
        keperluan: keperluan,
        periode: periode,
        showApprove: true,
        showReject: true,
        showDetail: true,
        showPdf: true,
      ),
    );
    print(
      '✅ SubmissionStore: added ${_submissions.length} items',
    ); // tambah ini
  }
}
