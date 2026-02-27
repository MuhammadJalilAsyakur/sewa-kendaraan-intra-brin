import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/sewa_kendaraan.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/form_indentitas.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/katalog_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/sewa_kendaraan_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';
import '../../widgets/tracking_card.dart';

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
      appBar: AppBar(
        title: const Text('Tracking', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // cukup ini
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              context.read<TrackingProvider>().refresh();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(child: _buildStatusFilter()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdown('Semua Waktu')),
                ],
              ),
            ),
            Expanded(
              child: Consumer<TrackingProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Terjadi Kesalahan',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => provider.refresh(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
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
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada data tracking',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // List of tracking items
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: trackingList.length,
                    itemBuilder: (context, index) {
                      final item = trackingList[index];

                      return TrackingCard(
                        trackingItem: item,
                        onEdit: () {
                          final sewaProvider = context
                              .read<SewaKendaraanProvider>();
                          final trackingProvider = context
                              .read<TrackingProvider>();

                          final detail = trackingProvider.getById(item.id);

                          if (detail?.detailData != null) {
                            sewaProvider.loadForEdit(
                              detail!.detailData!,
                              item.id,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const SewaKendaraanPage(), // page stepper form kamu
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data tidak bisa diedit'),
                              ),
                            );
                          }
                        },
                        onCancel: () {
                          _showCancelDialog(context, item.id);
                        },
                        onViewPdf: () {
                          _handleDownloadPdf(context, item.id);
                        },
                        onViewDetail: () {
                          _handleViewDetail(context, item.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Consumer<TrackingProvider>(
      builder: (context, provider, child) {
        final filterLabels = {
          TrackingFilter.all: 'Semua Status',
          TrackingFilter.pending: 'Menunggu',
          TrackingFilter.approved: 'Disetujui',
          TrackingFilter.rejected: 'Ditolak',
        };

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TrackingFilter>(
              value: provider.currentFilter,
              isExpanded: true,
              items: TrackingFilter.values.map((filter) {
                return DropdownMenuItem<TrackingFilter>(
                  value: filter,
                  child: Text(filterLabels[filter] ?? 'Semua'),
                );
              }).toList(),
              onChanged: (filter) {
                if (filter != null) {
                  provider.setFilter(filter);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: [DropdownMenuItem(value: value, child: Text(value))],
          onChanged: (val) {
            // TODO: Implement time filter
          },
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, String id) {
    // TODO: Navigate to edit page
    print("Edit: $id");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fitur edit belum tersedia')));
  }

  void _showCancelDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Permohonan'),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan permohonan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              // Show loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membatalkan permohonan...')),
              );

              final provider = context.read<TrackingProvider>();
              final success = await provider.cancelSubmission(id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Permohonan berhasil dibatalkan'
                          : 'Gagal membatalkan permohonan',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDownloadPdf(BuildContext context, String id) async {
    final provider = context.read<TrackingProvider>();

    // Show loading
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mengunduh PDF...')));

    final path = await provider.downloadPdf(id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            path != null
                ? 'PDF berhasil diunduh: $path'
                : 'Gagal mengunduh PDF',
          ),
          backgroundColor: path != null ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _handleViewDetail(BuildContext context, String id) async {
    final provider = context.read<TrackingProvider>();

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await provider.loadTrackingDetail(id);

    if (context.mounted) {
      Navigator.pop(context); // Close loading

      if (provider.selectedItem != null) {
        // TODO: Navigate to detail page
        print('Detail loaded: ${provider.selectedItem!.id}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail: ${provider.selectedItem!.judul}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat detail'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
