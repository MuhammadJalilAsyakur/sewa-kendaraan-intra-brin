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
    return GestureDetector(
      onTap: onViewDetail, // tap card → masuk detail
      child: Container(
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
                      color: _statusBgColor(trackingItem.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trackingItem.status,
                      style: TextStyle(
                        color: _statusColor(trackingItem.status),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat(
                      'dd MMM yyyy',
                    ).format(trackingItem.tanggalPengajuan),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Judul
              Text(
                trackingItem.judul,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Info rows
              _InfoRow(
                icon: Icons.notes_outlined,
                label: trackingItem.keperluan,
              ),
              const SizedBox(height: 4),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: trackingItem.periode,
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Detail selalu tampil
                  _ActionButton(
                    label: 'Detail',
                    icon: Icons.info_outline_rounded,
                    color: const Color(0xFF1565C0),
                    onTap: onViewDetail,
                  ),
                  if (trackingItem.canEdit) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'Edit',
                      icon: Icons.edit_outlined,
                      color: const Color(0xFF6A1B9A),
                      onTap: onEdit,
                    ),
                  ],
                  if (trackingItem.canCancel) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'Batalkan',
                      icon: Icons.cancel_outlined,
                      color: const Color(0xFFC62828),
                      onTap: onCancel,
                    ),
                  ],
                  if (trackingItem.canViewPdf) ...[
                    const SizedBox(width: 8),
                    _ActionButton(
                      label: 'PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      color: Colors.grey.shade600,
                      onTap: onViewPdf,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 15),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
