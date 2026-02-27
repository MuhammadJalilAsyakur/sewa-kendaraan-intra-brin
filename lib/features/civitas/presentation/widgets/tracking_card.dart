import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/tracking_item.dart';

class TrackingCard extends StatelessWidget {
  final TrackingItem trackingItem;
  final VoidCallback? onEdit;
  final VoidCallback? onCancel;
  final VoidCallback? onViewPdf;
  final VoidCallback? onViewDetail;

  const TrackingCard({
    super.key,
    required this.trackingItem,
    this.onEdit,
    this.onCancel,
    this.onViewPdf,
    this.onViewDetail,
  });

  Color _statusColor(String status) {
    switch (status) {
      case "Menunggu Persetujuan":
        return const Color(0xFFFFA726); // Orange
      case "Disetujui":
        return const Color(0xFF2ECC71); // Green
      case "Ditolak":
        return const Color(0xFFE74C3C); // Red
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(trackingItem.status),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              trackingItem.status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tanggal Pengajuan
          Text(
            DateFormat('dd MMM yyyy').format(trackingItem.tanggalPengajuan),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),

          // Judul Permohonan
          Text(
            trackingItem.judul,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // Keperluan
          Text(
            "Keperluan: ${trackingItem.keperluan}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 2),

          // Periode Peminjaman
          Text(
            "Periode Peminjamaan: ${trackingItem.periode}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 16),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    List<Widget> buttons = [];

    if (trackingItem.canEdit) {
      buttons.add(
        _buildButton(
          text: "Edit",
          color: const Color(0xFF6A4FB6),
          icon: Icons.edit,
          onPressed: onEdit,
        ),
      );
    }

    if (trackingItem.canCancel) {
      buttons.add(
        _buildButton(
          text: "Batalkan",
          color: const Color(0xFFE74C3C),
          icon: Icons.close,
          onPressed: onCancel,
        ),
      );
    }

    if (trackingItem.canViewPdf) {
      buttons.add(
        _buildButton(
          text: "Lihat PDF",
          color: const Color(0xFF00BAD1),
          icon: Icons.picture_as_pdf,
          onPressed: onViewPdf,
        ),
      );
    }

    if (trackingItem.canViewDetail) {
      buttons.add(
        _buildButton(
          text: "Lihat Detail",
          color: const Color(0xFF00BAD1),
          icon: Icons.info_outline,
          onPressed: onViewDetail,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          children: buttons,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        elevation: 0,
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}