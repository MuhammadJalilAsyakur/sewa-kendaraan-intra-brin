import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';
import 'package:vehicle_rental/features/reviewer/domain/entities/reviewer_item.dart';
import 'reviewer_detail_page.dart';

class ReviewerPage extends StatelessWidget {
  const ReviewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviewer',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () =>
                context.read<ReviewerProvider>().loadReviewerList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ReviewerProvider>(
              builder: (context, provider, _) => Row(
                children: [
                  Expanded(
                    child: _DropdownFilter(
                      value: provider.selectedStatus,
                      items: const [
                        'Semua Status',
                        'Menunggu Persetujuan',
                        'Disetujui',
                        'Ditolak',
                      ],
                      onChanged: (val) {
                        if (val != null) provider.filterByStatus(val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownFilter(
                      value: provider.selectedWaktu,
                      items: const [
                        'Semua Waktu',
                        'Hari Ini',
                        'Minggu Ini',
                        'Bulan Ini',
                      ],
                      onChanged: (val) {
                        if (val != null) provider.setSelectedWaktu(val);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List
          Expanded(
            child: Consumer<ReviewerProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(child: Text('Error: ${provider.error}'));
                }
                if (provider.filteredList.isEmpty) {
                  return const Center(child: Text('Tidak ada pengajuan'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.filteredList.length,
                  itemBuilder: (context, index) {
                    return _ReviewerCard(item: provider.filteredList[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownFilter({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _ReviewerCard extends StatelessWidget {
  final ReviewerItem item;

  const _ReviewerCard({required this.item});

  Color _statusColor(String status) {
    switch (status) {
      case 'Disetujui':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(item.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.status,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),

            // Tanggal
            Text(
              DateFormat('dd MMM yyyy').format(item.tanggalPengajuan),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 4),

            // Judul
            Text(
              item.judul,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),

            // Nama pemohon & satuan kerja (tambahan dari tracking)
            Text('Pemohon: ${item.namaPemohon}'),
            Text('Satuan Kerja: ${item.satuanKerja}'),
            Text('Keperluan: ${item.keperluan}'),
            Text('Periode Peminjaman: ${item.periode}'),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (item.showDetail)
                  _ActionButton(
                    label: 'Detail',
                    icon: Icons.info_outline,
                    color: Colors.blue,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewerDetailPage(item: item),
                      ),
                    ),
                  ),
                if (item.showPdf) ...[
                  const SizedBox(width: 8),
                  _ActionButton(
                    label: 'PDF',
                    icon: Icons.picture_as_pdf,
                    color: Colors.grey,
                    onTap: () =>
                        context.read<ReviewerProvider>().getPdf(item.id),
                  ),
                ],
                // if (item.showApprove) ...[
                //   const SizedBox(width: 8),
                //   _ActionButton(
                //     label: 'Terima',
                //     icon: Icons.check,
                //     color: Colors.green,
                //     onTap: () => _confirmApprove(context, item.id),
                //   ),
                // ],
                // if (item.showReject) ...[
                //   const SizedBox(width: 8),
                //   _ActionButton(
                //     label: 'Tolak',
                //     icon: Icons.close,
                //     color: Colors.red,
                //     onTap: () => _confirmReject(context, item.id),
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmApprove(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Approve'),
        content: const Text('Yakin ingin menyetujui pengajuan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context);
              final success = await context.read<ReviewerProvider>().approve(
                id,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Pengajuan disetujui' : 'Gagal menyetujui',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Terima', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmReject(BuildContext context, String id) {
    final alasanController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Reject'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan alasan penolakan:'),
            const SizedBox(height: 8),
            TextField(
              controller: alasanController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Alasan penolakan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (alasanController.text.isEmpty) return;
              Navigator.pop(context);
              final success = await context.read<ReviewerProvider>().reject(
                id,
                alasanController.text,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Pengajuan ditolak' : 'Gagal menolak',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Tolak', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 16),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
