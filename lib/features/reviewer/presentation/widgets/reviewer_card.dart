import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'package:vehicle_rental/features/reviewer/presentation/pages/reviewer_detail_page.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';
import 'package:vehicle_rental/features/reviewer/presentation/widgets/reviewer_confirm_dialog.dart';
import 'reviewer_action_button.dart';
import 'reviewer_info_row.dart';

class ReviewerCard extends StatelessWidget {
  final ReviewerItem item;

  const ReviewerCard({super.key, required this.item});

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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: status + tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusBgColor(item.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      color: _statusColor(item.status),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(item.tanggalPengajuan),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              item.judul,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            ReviewerInfoRow(
              icon: Icons.person_outline,
              label: item.namaPemohon,
            ),
            const SizedBox(height: 4),
            ReviewerInfoRow(
              icon: Icons.business_outlined,
              label: item.satuanKerja,
            ),
            const SizedBox(height: 4),
            ReviewerInfoRow(icon: Icons.notes_outlined, label: item.keperluan),
            const SizedBox(height: 4),
            ReviewerInfoRow(
              icon: Icons.calendar_today_outlined,
              label: item.periode,
            ),

            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.showDetail)
                  ReviewerActionButton(
                    label: 'Detail',
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF1565C0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewerDetailPage(item: item),
                      ),
                    ),
                  ),
                if (item.showPdf) ...[
                  const SizedBox(width: 8),
                  ReviewerActionButton(
                    label: 'PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    color: Colors.grey.shade600,
                    onTap: () =>
                        context.read<ReviewerProvider>().getPdf(item.id),
                  ),
                ],
                // if (item.showApprove) ...[
                //   const SizedBox(width: 8),
                //   ReviewerActionButton(
                //     label: 'Terima',
                //     icon: Icons.check_circle_outline_rounded,
                //     color: const Color(0xFF2E7D32),
                //     onTap: () =>
                //         ReviewerConfirmDialog.showApprove(context, item.id),
                //   ),
                // ],
                // if (item.showReject) ...[
                //   const SizedBox(width: 8),
                //   ReviewerActionButton(
                //     label: 'Tolak',
                //     icon: Icons.cancel_outlined,
                //     color: const Color(0xFFC62828),
                //     onTap: () =>
                //         ReviewerConfirmDialog.showReject(context, item.id),
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
