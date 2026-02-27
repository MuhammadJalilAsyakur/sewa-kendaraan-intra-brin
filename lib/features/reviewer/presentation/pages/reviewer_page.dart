import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/reviewer/presentation/providers/reviewer_provider.dart';
import 'package:vehicle_rental/features/reviewer/presentation/widgets/reviewer_card.dart';
import 'package:vehicle_rental/features/reviewer/presentation/widgets/reviewer_dropdown_filter.dart';

class ReviewerPage extends StatelessWidget {
  const ReviewerPage({super.key});

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
          'Reviewer',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.black54),
            onPressed: () =>
                context.read<ReviewerProvider>().loadReviewerList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Consumer<ReviewerProvider>(
              builder: (context, provider, _) => Row(
                children: [
                  Expanded(
                    child: ReviewerDropdownFilter(
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
                    child: ReviewerDropdownFilter(
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
          Expanded(
            child: Consumer<ReviewerProvider>(
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
                        Text(
                          'Terjadi kesalahan',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  );
                }
                if (provider.filteredList.isEmpty) {
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
                          'Tidak ada pengajuan',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.filteredList.length,
                  itemBuilder: (context, index) {
                    return ReviewerCard(item: provider.filteredList[index]);
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
