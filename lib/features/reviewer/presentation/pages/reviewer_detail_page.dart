// reviewer_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/presentation/widgets/reviewer_confirm_dialog.dart';
import 'package:vehicle_rental/features/reviewer/presentation/widgets/reviewer_detail_section.dart';

class ReviewerDetailPage extends StatelessWidget {
  final ReviewerItem item;

  const ReviewerDetailPage({super.key, required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFF2E7D32);
      case 'Ditolak':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFFE65100);
    }
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'Disetujui':
        return const Color(0xFFE8F5E9);
      case 'Ditolak':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFFFF3E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pengajuan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _statusBgColor(item.status),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.status == 'Disetujui'
                          ? Icons.check_circle_outline_rounded
                          : item.status == 'Ditolak'
                              ? Icons.cancel_outlined
                              : Icons.hourglass_empty_rounded,
                      color: _statusColor(item.status),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusBgColor(item.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status,
                      style: TextStyle(
                        color: _statusColor(item.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Informasi Pengajuan
            ReviewerDetailSection(
              title: 'Informasi Pengajuan',
              icon: Icons.description_outlined,
              rows: [
                ReviewerDetailRow(
                  label: 'Tanggal',
                  value: DateFormat('dd MMM yyyy').format(item.tanggalPengajuan),
                ),
                ReviewerDetailRow(label: 'Judul', value: item.judul),
                ReviewerDetailRow(label: 'Keperluan', value: item.keperluan),
                ReviewerDetailRow(label: 'Periode', value: item.periode),
              ],
            ),
            const SizedBox(height: 12),

            // Data Pemohon
            ReviewerDetailSection(
              title: 'Data Pemohon',
              icon: Icons.person_outline_rounded,
              rows: [
                ReviewerDetailRow(label: 'Nama', value: item.namaPemohon),
                ReviewerDetailRow(
                    label: 'Satuan Kerja', value: item.satuanKerja),
              ],
            ),
            const SizedBox(height: 24),

            // Action buttons
            if (item.showApprove || item.showReject)
              Row(
                children: [
                  if (item.showApprove)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            ReviewerConfirmDialog.showApprove(context, item.id),
                        icon: const Icon(Icons.check_circle_outline_rounded,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Terima',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  if (item.showApprove && item.showReject)
                    const SizedBox(width: 12),
                  if (item.showReject)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC62828),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            ReviewerConfirmDialog.showReject(context, item.id),
                        icon: const Icon(Icons.cancel_outlined,
                            color: Colors.white, size: 18),
                        label: const Text(
                          'Tolak',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}