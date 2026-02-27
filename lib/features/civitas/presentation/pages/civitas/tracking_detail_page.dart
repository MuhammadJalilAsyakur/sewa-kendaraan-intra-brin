import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/civitas/domain/entities/tracking_item.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';


class TrackingDetailPage extends StatefulWidget {
  final String trackingId;

  const TrackingDetailPage({
    super.key,
    required this.trackingId,
  });

  @override
  State<TrackingDetailPage> createState() => _TrackingDetailPageState();
}

class _TrackingDetailPageState extends State<TrackingDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingProvider>().loadTrackingDetail(widget.trackingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengajuan'),
        elevation: 0,
      ),
      body: Consumer<TrackingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _ErrorView(
              message: provider.error!,
              onRetry: () => provider.loadTrackingDetail(widget.trackingId),
            );
          }

          final item = provider.selectedItem;
          if (item == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          return _DetailContent(item: item);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final TrackingItem item;

  const _DetailContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatusBanner(status: item.status),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailSection(
                  title: 'Informasi Pengajuan',
                  children: [
                    _DetailRow(label: 'ID Pengajuan', value: item.id),
                    _DetailRow(label: 'Judul', value: item.judul),
                    _DetailRow(label: 'Keperluan', value: item.keperluan),
                    _DetailRow(label: 'Periode', value: item.periode),
                    _DetailRow(
                      label: 'Tanggal Pengajuan',
                      value: DateFormat('dd MMMM yyyy, HH:mm').format(item.tanggalPengajuan),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (item.canEdit || item.canCancel || item.canViewPdf)
                  _ActionButtons(item: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String status;

  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: config.color.withOpacity(0.1),
      child: Column(
        children: [
          Icon(config.icon, size: 64, color: config.color),
          const SizedBox(height: 16),
          Text(
            status,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, IconData icon}) _getConfig(String status) {
    switch (status) {
      case 'Menunggu Persetujuan':
        return (color: Colors.orange, icon: Icons.hourglass_empty);
      case 'Disetujui':
        return (color: Colors.green, icon: Icons.check_circle);
      case 'Ditolak':
        return (color: Colors.red, icon: Icons.cancel);
      default:
        return (color: Colors.grey, icon: Icons.info);
    }
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _DetailSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final TrackingItem item;

  const _ActionButtons({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (item.canEdit)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur edit belum tersedia')),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Pengajuan'),
            ),
          ),
        if (item.canEdit && item.canCancel) const SizedBox(height: 12),
        if (item.canCancel)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showCancelDialog(context),
              icon: const Icon(Icons.close),
              label: const Text('Batalkan Pengajuan'),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            ),
          ),
        if (item.canViewPdf) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final path = await context.read<TrackingProvider>().downloadPdf(item.id);
                if (context.mounted && path != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PDF diunduh: $path')),
                  );
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Unduh Surat Persetujuan (PDF)'),
            ),
          ),
        ],
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan Pengajuan'),
        content: const Text('Apakah Anda yakin ingin membatalkan pengajuan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await context.read<TrackingProvider>().cancelSubmission(item.id);
              
              if (context.mounted) {
                if (success) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pengajuan berhasil dibatalkan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}