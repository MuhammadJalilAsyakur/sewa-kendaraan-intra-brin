import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/pages/civitas/sewa_kendaraan_page.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/pages/civitas/tracking_civitas_page.dart';

class KatalogPage extends StatelessWidget {
  const KatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            final provider = context.read<SewaKendaraanProvider>();
            if (provider.currentStep > 0) {
              provider.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Peminjaman kendaraan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

          

            /// Card Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Reviewer
                  _MenuCard(
                    title: "Peminjaman Kendaraan",
                    iconPath: 'assets/icons/reviews.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SewaKendaraanPage(),
                        ),
                      );
                    },
                  ),

                  /// Civitas
                  _MenuCard(
                    title: "Tracking Peminjaman Kendaraan",
                    iconPath: 'assets/icons/worker.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackingPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// COMPONENT CARD
class _MenuCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 160,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 3),
              color: Colors.black12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
