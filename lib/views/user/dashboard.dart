// ======== Import Package ========
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
import 'package:alumni_busfa/views/artikel.dart';
import 'package:alumni_busfa/data/data_artikel.dart';
import 'package:url_launcher/url_launcher.dart';

// ======== Home Screen ========
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    String userName = user?.displayName ?? user?.email?.split('@')[0] ?? "User";

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(userName),
          const SizedBox(height: 50),
          _buildMenu(context),
          const SizedBox(height: 30),
          _buildArtikelSection(context),
        ],
      ),
    );
  }

  // ======== Header Widget ========
  Widget _buildHeader(String userName) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 50, top: 100, bottom: 100),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
        gradient: LinearGradient(
          colors: [Colors.blue, Color.fromRGBO(76, 201, 254, 1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Halo, $userName",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "Siap untuk Optimasi Bisnismu?",
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // ======== Menu Widget ========
  Widget _buildMenu(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _menuItem(
            "Analisis",
            Icons.search,
            onTap: () {
              _showBusinessTypeDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, size: 40, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  void _showBusinessTypeDialog(BuildContext context) {
    String? selectedBusinessType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pilih Jenis Usaha'),
              content: DropdownButton<String>(
                isExpanded: true,
                value: selectedBusinessType,
                hint: const Text('Pilih jenis usaha'),
                items:
                    <String>[
                      'Kafe & Kedai Kopi',
                      'Angkringan',
                      'Rumah Makan',
                      'Street Food',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBusinessType = newValue;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Batal'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Get.to(() => const AnalisisScreens());
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildArtikelSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Artikel",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtikelScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Lihat Semua >",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: artikelList.take(5).length,
              itemBuilder: (context, index) => _artikelItem(artikelList[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _artikelItem(Map<String, String> artikel) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => _launchURL(artikel["link"]!),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 220,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      artikel["gambar"]!,
                      height: 100,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    artikel["judul"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
