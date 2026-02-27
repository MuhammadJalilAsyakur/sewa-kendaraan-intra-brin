import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/sewa_kendaraan_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/tracking_detail_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';
import '../../widgets/tracking_card.dart';
import '../../widgets/tracking_dropdown_filter.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingProvider>().loadTrackingList();
    });
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
          'Tracking',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black54),
            onPressed: () => context.read<TrackingProvider>().refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Consumer<TrackingProvider>(
              builder: (context, provider, _) {
                final filterLabels = {
                  TrackingFilter.all: 'Semua Status',
                  TrackingFilter.pending: 'Menunggu',
                  TrackingFilter.approved: 'Disetujui',
                  TrackingFilter.rejected: 'Ditolak',
                };
                return Row(
                  children: [
                    Expanded(
                      child: TrackingDropdownFilter<TrackingFilter>(
                        value: provider.currentFilter,
                        items: TrackingFilter.values.map((f) {
                          return DropdownMenuItem(
                            value: f,
                            child: Text(filterLabels[f] ?? 'Semua'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) provider.setFilter(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TrackingDropdownFilter<String>(
                        value: 'Semua Waktu',
                        items: const [
                          DropdownMenuItem(
                            value: 'Semua Waktu',
                            child: Text('Semua Waktu'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // List
          Expanded(
            child: Consumer<TrackingProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Terjadi Kesalahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD32F2F),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => provider.refresh(),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            'Coba Lagi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final trackingList = provider.filteredItems;

                if (trackingList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 56,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada data tracking',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: trackingList.length,
                  itemBuilder: (context, index) {
                    final item = trackingList[index];
                    return TrackingCard(
                      trackingItem: item,
                      onEdit: () => _handleEdit(context, item.id),
                      onCancel: () => _showCancelDialog(context, item.id),
                      onViewPdf: () => _handleDownloadPdf(context, item.id),
                      onViewDetail: () => _handleViewDetail(context, item.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleEdit(BuildContext context, String id) {
    final sewaProvider = context.read<SewaKendaraanProvider>();
    final trackingProvider = context.read<TrackingProvider>();
    final detail = trackingProvider.getById(id);

    if (detail?.detailData != null) {
      sewaProvider.loadForEdit(detail!.detailData!, id);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SewaKendaraanPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Data tidak bisa diedit'),
          backgroundColor: Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  void _showCancelDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
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
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFFC62828),
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Batalkan Permohonan?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Permohonan yang dibatalkan tidak dapat dikembalikan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Kembali',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC62828),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        final success = await context
                            .read<TrackingProvider>()
                            .cancelSubmission(id);
                        if (context.mounted) {
                          _showSnackbar(
                            context,
                            success
                                ? 'Permohonan berhasil dibatalkan'
                                : 'Gagal membatalkan permohonan',
                            success,
                          );
                        }
                      },
                      child: const Text(
                        'Batalkan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDownloadPdf(BuildContext context, String id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10),
            Text('Mengunduh PDF...'),
          ],
        ),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );

    final path = await context.read<TrackingProvider>().downloadPdf(id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      _showSnackbar(
        context,
        path != null ? 'PDF berhasil diunduh' : 'Gagal mengunduh PDF',
        path != null,
      );
    }
  }

  void _handleViewDetail(BuildContext context, String id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await context.read<TrackingProvider>().loadTrackingDetail(id);

    if (context.mounted) {
      Navigator.pop(context); // tutup loading

      final selected = context.read<TrackingProvider>().selectedItem;
      if (selected != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TrackingDetailPage(trackingId: id)),
        );
      } else {
        _showSnackbar(context, 'Gagal memuat detail', false);
      }
    }
  }

  void _showSnackbar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_outline : Icons.error_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: success
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
