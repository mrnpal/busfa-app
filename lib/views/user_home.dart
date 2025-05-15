import 'package:alumni_busfa/maps/map_with_custom_info_windows.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Future<String?> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('alumniVerified')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        return snapshot.data()?['name'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background biru dengan lengkungan
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 1, // Bagian atas (biru dengan lengkungan)
                  child: ClipPath(
                    clipper: CustomBackgroundClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.green, // Warna biru
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1, // Bagian bawah (putih)
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white, // Warna putih
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Konten utama
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 130),
                FutureBuilder<String?>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        "Halo,\nLoading...",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white, // Teks putih agar kontras
                        ),
                      );
                    }
                    final userName = snapshot.data ?? "Pengguna";
                    return Text(
                      "Halo, $userName 👋\nSelamat datang di Aplikasi Alumni Pondok!",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // Teks putih agar kontras
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Tambahkan card dalam satu baris
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Scroll horizontal
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Card 1
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/feature1');
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 100, // Lebar card
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.people,
                                  size: 48,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Kelola Alumni",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card 2
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/feature2');
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 100, // Lebar card
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.work, size: 48, color: Colors.green),
                                SizedBox(height: 8),
                                Text(
                                  "Lowongan Kerja",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Card 3
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/alumni-map');
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 100, // Lebar card
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.event,
                                  size: 48,
                                  color: Colors.orange,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Kegiatan Alumni",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Ikon notifikasi di pojok kanan atas
          Positioned(
            top: 75,
            right: 16,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text("Notifikasi"),
                        content: const Text("Belum ada notifikasi baru."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                );
              },
              child: Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    size: 30,
                    color: Colors.white,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "3",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Kegiatan'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Grup'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Navigasi berdasarkan indeks
          if (index == 0) {
            Navigator.pushNamed(context, '/user-dashboard');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/activities');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/grup');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/alumni-map');
          }
        },
      ),
    );
  }
}

// Custom Clipper untuk membuat lengkungan
class CustomBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.7); // Garis ke bawah (geser ke atas)
    path.quadraticBezierTo(
      size.width / 2, // Titik kontrol di tengah
      size.height * 0.6, // Tinggi lengkungan (geser ke atas)
      size.width, // Garis ke kanan
      size.height * 0.7, // Garis ke atas (geser ke atas)
    );
    path.lineTo(size.width, 0); // Garis ke atas
    path.close(); // Tutup path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
