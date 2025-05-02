import 'package:alumni_busfa/views/admin/dashboard/alumni_management.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final String adminName = "Admin Name"; // Ganti dengan nama admin yang sesuai

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Admin
            Text(
              'Selamat Datang, $adminName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Grid Fitur
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Jumlah kolom
                crossAxisSpacing: 16, // Jarak horizontal antar kotak
                mainAxisSpacing: 16, // Jarak vertikal antar kotak
                children: [
                  // Fitur 1
                  FeatureCard(
                    icon: Icons.people,
                    title: 'Kelola Alumni',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlumniManagement(),
                        ),
                      );
                    },
                  ),
                  // Fitur 2
                  FeatureCard(
                    icon: Icons.work,
                    title: 'Lowongan Kerja',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobVacanciesPage(),
                        ),
                      );
                    },
                  ),
                  // Fitur 3
                  FeatureCard(
                    icon: Icons.analytics,
                    title: 'Laporan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsPage()),
                      );
                    },
                  ),
                  // Fitur 4
                  FeatureCard(
                    icon: Icons.settings,
                    title: 'Pengaturan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
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

// Widget untuk Kotak Fitur
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.blueGrey),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Placeholder untuk Fitur
class ManageAlumniPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Alumni')),
      body: const Center(child: Text('Halaman Kelola Alumni')),
    );
  }
}

class JobVacanciesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lowongan Kerja')),
      body: const Center(child: Text('Halaman Lowongan Kerja')),
    );
  }
}

class ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan')),
      body: const Center(child: Text('Halaman Laporan')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: const Center(child: Text('Halaman Pengaturan')),
    );
  }
}
