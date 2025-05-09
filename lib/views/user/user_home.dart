import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<int> _getAlumniCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('alumniVerified').get();
    return snapshot.docs.length;
  }

  Future<Map<String, dynamic>?> _getLatestActivity() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('activities')
            .orderBy('date', descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beranda Alumni")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Assalamu'alaikum,\nSelamat datang di Aplikasi Alumni Pondok!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Total Alumni
            FutureBuilder<int>(
              future: _getAlumniCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups),
                    title: const Text("Total Alumni Terverifikasi"),
                    subtitle: Text("${snapshot.data ?? 0} orang"),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Kegiatan Terbaru
            FutureBuilder<Map<String, dynamic>?>(
              future: _getLatestActivity(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.data;
                if (data == null) {
                  return const Text("Belum ada kegiatan.");
                }
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(data['title'] ?? 'Kegiatan'),
                    subtitle: Text(data['description'] ?? ''),
                    trailing: Text(data['date'] ?? ''),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Tombol lihat kegiatan
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/activities');
                },
                child: const Text("Lihat Semua Kegiatan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
