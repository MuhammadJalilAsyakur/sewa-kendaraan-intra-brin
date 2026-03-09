import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/tracking_civitas_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';
import '../../widgets/dokumen_upload_field.dart';
import '../../widgets/section_card.dart';
import '../../widgets/summary_card.dart';

class FormDokumen extends StatelessWidget {
  const FormDokumen({super.key});

  String _formatDate(DateTime? date, {bool withTime = false}) {
    if (date == null) return '-';
    return withTime
        ? DateFormat('dd MMM yyyy, HH:mm').format(date)
        : DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SewaKendaraanController>();

    return Obx(() {
      final dokumen = controller.dokumenPersyaratan;
      final kegiatan = controller.kegiatanDanTujuan;
      final waktu = controller.waktuPeminjaman;
      final penumpang = controller.dataPenumpangDanPengemudi;
      final dataPemohon = controller.dataPemohon;
      final adminInfo = controller.administrasiInfo;
      final pj = controller.dataPenanggungJawab;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dokumen Persyaratan
            SectionCard(
              title: 'Dokumen Persyaratan',
              icon: Icons.upload_file_outlined,
              iconColor: const Color(0xFFD32F2F),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload file persyaratan dalam format PDF',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 12),
                  DokumenUploadField(
                    label: 'Surat Tugas *',
                    fileName: dokumen.suratTugas,
                    onBrowse: () => controller.pickSuratTugas(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Ringkasan Permohonan
            SummaryCard(
              title: 'Ringkasan Permohonan',
              icon: Icons.directions_car_outlined,
              iconColor: const Color(0xFF2E7D32),
              items: [
                SummaryItem('Nama Kegiatan', kegiatan.namaKegiatan),
                SummaryItem('Kawasan', adminInfo.kawasan),
                SummaryItem('Tujuan Perjalanan', kegiatan.tujuanPerjalanan),
                SummaryItem('Keperluan', kegiatan.keperluan),
                SummaryItem(
                  'Mulai Pinjam',
                  _formatDate(waktu.tanggalMulaiPinjam, withTime: true),
                ),
                SummaryItem(
                  'Selesai Pinjam',
                  _formatDate(waktu.tanggalSelesaiPinjam, withTime: true),
                ),
                SummaryItem(
                  'Jumlah Penumpang',
                  penumpang.jumlahPenumpang?.toString(),
                ),
                SummaryItem('Status Pengemudi', penumpang.statusPengemudi),
              ],
            ),
            const SizedBox(height: 16),

            // Ringkasan Identitas Pemohon
            SummaryCard(
              title: 'Identitas Pemohon',
              icon: Icons.person_outline_rounded,
              iconColor: const Color(0xFF1565C0),
              items: [
                SummaryItem('Nama', dataPemohon?.nama),
                SummaryItem('NIP', dataPemohon?.nip),
                SummaryItem('Nomor Ponsel', dataPemohon?.nomorHp),
                SummaryItem('Satuan Kerja', dataPemohon?.satuanKerja),
                SummaryItem(
                  'Tgl Permohonan',
                  _formatDate(adminInfo.tanggalPermohonan, withTime: true),
                ),
                SummaryItem(
                  'No. Surat Pengantar',
                  adminInfo.nomorSuratPengantar,
                ),
                SummaryItem(
                  'Tgl Surat Pengantar',
                  _formatDate(adminInfo.tanggalSuratPengantar),
                ),
                SummaryItem('Keterangan', adminInfo.keteranganPemohon),
              ],
            ),
            const SizedBox(height: 16),

            // Ringkasan Penanggung Jawab
            SummaryCard(
              title: 'Identitas Penanggung Jawab',
              icon: Icons.badge_outlined,
              iconColor: const Color(0xFF6A1B9A),
              items: [
                SummaryItem('Nama', pj.namaPenanggungJawab),
                SummaryItem('Nomor Ponsel', pj.nomorHpPenanggungJawab),
                SummaryItem('Email', pj.email),
              ],
            ),
            const SizedBox(height: 24),

            // Button Kirim
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: controller.isLoading
                    ? null
                    : () => _handleSubmit(context, controller),
                child: controller.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Kirim Permohonan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _handleSubmit(
    BuildContext context,
    SewaKendaraanController controller,
  ) async {
    final trackingData = await controller.submit();
    if (trackingData == null || !context.mounted) return;

    final trackingController = Get.find<TrackingController>();

    if (trackingData['isEdit'] == true) {
      trackingController.updateTrackingItem(
        trackingData['id'],
        trackingData['detailData'],
      );
    } else {
      await trackingController.createTrackingFromData(
        id: trackingData['id'],
        status: trackingData['status'],
        tanggalPengajuan: trackingData['tanggalPengajuan'],
        judul: trackingData['judul'],
        keperluan: trackingData['keperluan'],
        periode: trackingData['periode'],
        detailData: trackingData['detailData'],
      );
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF2E7D32),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Berhasil!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Permohonan sewa kendaraan berhasil dikirim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.find<SewaKendaraanController>().resetForm();
                    Navigator.pop(dialogContext); // close dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const TrackingPage()),
                    );
                  },
                  child: const Text(
                    'Lihat Tracking',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
