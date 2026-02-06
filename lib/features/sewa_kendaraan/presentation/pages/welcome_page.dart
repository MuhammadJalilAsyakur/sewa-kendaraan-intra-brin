import 'package:flutter/material.dart';
import 'package:vehicle_rental/features/sewa_kendaraan/presentation/pages/civitas/civitas_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe5e7eb), // abu muda mirip desain
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// Judul
            const Text(
              "Selamat Datang",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            /// Card Container
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Reviewer
                  _MenuCard(
                    title: "Reviewer",
                    iconPath: 'assets/icons/reviews.png',
                    onTap: () {
                      // TODO: arahkan ke page reviewer (router clean-arch)
                      // context.read<AppRouter>().goReviewer();
                    },
                  ),

                  /// Civitas
                  _MenuCard(
                    title: "Civitas",
                    iconPath: 'assets/icons/worker.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CivitasPage(),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
