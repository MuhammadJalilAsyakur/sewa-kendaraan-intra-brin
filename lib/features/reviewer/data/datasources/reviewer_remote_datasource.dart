import 'package:dio/dio.dart';
import 'package:vehicle_rental/core/constants/api_constanst.dart';
import 'package:vehicle_rental/core/shared/submission_store.dart';
import 'package:vehicle_rental/features/reviewer/data/models/reviewer_item_model.dart';

abstract class ReviewerRemoteDatasource {
  Future<List<ReviewerItemModel>> getReviewerList();
  Future<ReviewerItemModel> getReviewerDetail(String id);
  Future<List<ReviewerItemModel>> getReviewerByStatus(String status);
  Future<void> approveSubmission(String id);
  Future<void> rejectSubmission(String id, String alasan);
  Future<String> downloadPdf(String id);
}

class ReviewerRemoteDatasourceImpl implements ReviewerRemoteDatasource {
  final Dio dio;

  ReviewerRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<ReviewerItemModel>> getReviewerList() async {
    // dummy dulu sampai backend siap
    await Future.delayed(const Duration(milliseconds: 500));
    final submissions = SubmissionStore().submissions;
    print('📦 SubmissionStore size: ${submissions.length}'); // tambah ini

    if (submissions.isEmpty) {
      return [
        ReviewerItemModel(
          id: 'dummy-1',
          status: 'Menunggu Persetujuan',
          tanggalPengajuan: DateTime.now(),
          judul: 'Permohonan Peminjaman Kendaraan',
          namaPemohon: 'Afrido Prayogi',
          satuanKerja: 'Pusat Data Dan Informasi',
          keperluan: 'Dinas Luar Kota',
          periode: '26/02/2026 08:00 S/D 27/02/2026 08:00',
          showApprove: true,
          showReject: true,
          showDetail: true,
          showPdf: false,
        ),
      ];
    }

    return submissions
        .map(
          (e) => ReviewerItemModel(
            id: e.id,
            status: e.status,
            tanggalPengajuan: e.tanggalPengajuan,
            judul: e.judul,
            namaPemohon: e.namaPemohon,
            satuanKerja: e.satuanKerja,
            keperluan: e.keperluan,
            periode: e.periode,
            showApprove: e.showApprove,
            showReject: e.showReject,
            showDetail: e.showDetail,
            showPdf: e.showPdf,
          ),
        )
        .toList();
  }

  @override
  Future<ReviewerItemModel> getReviewerDetail(String id) async {
    final response = await dio.get('${ApiConstants.reviewer}/$id');
    return ReviewerItemModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ReviewerItemModel>> getReviewerByStatus(String status) async {
    final response = await dio.get(
      ApiConstants.reviewer,
      queryParameters: {'status': status},
    );
    return (response.data['data'] as List)
        .map((e) => ReviewerItemModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> approveSubmission(String id) async {
    await dio.post('${ApiConstants.reviewer}/$id/approve');
  }

  @override
  Future<void> rejectSubmission(String id, String alasan) async {
    await dio.post(
      '${ApiConstants.reviewer}/$id/reject',
      data: {'alasan': alasan},
    );
  }

  @override
  Future<String> downloadPdf(String id) async {
    final response = await dio.get('${ApiConstants.reviewer}/$id/pdf');
    return response.data['url'];
  }
}
