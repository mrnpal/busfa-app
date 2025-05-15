import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

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

  Future<int> _getAlumniCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('alumniVerified').get();
    return snapshot.size;
  }

  Future<int> _getEventCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('kegiatan').get();
    return snapshot.size;
  }

  Future<int> _getJobCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('jobs').get();
    return snapshot.size;
  }

  Widget _buildProfileButton() {
    final user = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future:
          user != null
              ? FirebaseFirestore.instance
                  .collection('alumniVerified')
                  .doc(user.uid)
                  .get()
              : null,
      builder: (context, snapshot) {
        String? photoUrl;
        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data != null) {
            if (data.containsKey('profile-images') && data['profile-images'] != null) {
              photoUrl = data['profile-images'];
            } else if (data.containsKey('photoUrl') && data['photoUrl'] != null) {
              photoUrl = data['photoUrl'];
            } else if (data.containsKey('profilePictureUrl') && data['profilePictureUrl'] != null) {
              photoUrl = data['profilePictureUrl'];
            }
          }
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage:
                  photoUrl != null
                      ? NetworkImage(photoUrl) as ImageProvider
                      : const AssetImage('assets/home.png'),
              child:
                  photoUrl == null
                      ? const Icon(Icons.person, color: Colors.blue)
                      : null,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // App bar with user greeting
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F4C81), Color(0xFF3A7BD5)],
                  ),
                ),
                padding: const EdgeInsets.only(left: 24, bottom: 16, top: 65),
                alignment: Alignment.bottomLeft,
                child: FutureBuilder<String?>(
                  future: _getUserName(),
                  builder: (context, snapshot) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Welcome back,",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          snapshot.data ?? "Alumni Member",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: [_buildProfileButton()],
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick stats cards
                  SizedBox(
                    height: 120,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        FutureBuilder<int>(
                          future: _getAlumniCount(),
                          builder: (context, snapshot) {
                            return _buildStatCard(
                              title: "Alumni Connections",
                              value:
                                  snapshot.hasData ? "${snapshot.data}" : "-",
                              icon: Icons.people_alt_outlined,
                              color: const Color(0xFF6366F1),
                            );
                          },
                        ),
                        FutureBuilder<int>(
                          future: _getEventCount(),
                          builder: (context, snapshot) {
                            return _buildStatCard(
                              title: "Upcoming Events",
                              value:
                                  snapshot.hasData ? "${snapshot.data}" : "-",
                              icon: Icons.event_outlined,
                              color: const Color(0xFF10B981),
                            );
                          },
                        ),
                        FutureBuilder<int>(
                          future: _getJobCount(),
                          builder: (context, snapshot) {
                            return _buildStatCard(
                              title: "New Jobs",
                              value:
                                  snapshot.hasData ? "${snapshot.data}" : "-",
                              icon: Icons.work_outline,
                              color: const Color(0xFFF59E0B),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Features grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildFeatureTile(
                        icon: Icons.map_outlined,
                        title: "Alumni Map",
                        color: const Color(0xFF3B82F6),
                        onTap:
                            () => Navigator.pushNamed(context, '/alumni-map'),
                      ),
                      _buildFeatureTile(
                        icon: Icons.work_outline,
                        title: "Job Board",
                        color: const Color(0xFF10B981),
                        onTap: () => Navigator.pushNamed(context, '/feature2'),
                      ),
                      _buildFeatureTile(
                        icon: Icons.forum_outlined,
                        title: "Discussion",
                        color: const Color(0xFFF59E0B),
                        onTap: () => Navigator.pushNamed(context, '/grup'),
                      ),
                      _buildFeatureTile(
                        icon: Icons.school_outlined,
                        title: "Mentorship",
                        color: const Color(0xFF8B5CF6),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildModernNavBar(),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 0)
              Navigator.pushNamed(context, '/user-dashboard');
            else if (index == 1)
              Navigator.pushNamed(context, '/activities');
            else if (index == 2)
              Navigator.pushNamed(context, '/grup');
            else if (index == 3)
              Navigator.pushNamed(context, '/alumni-map');
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF0F4C81),
          unselectedItemColor: Colors.grey[600],
          selectedLabelStyle: const TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == 0
                          ? const Color(0xFF0F4C81).withOpacity(0.1)
                          : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  size: 24,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == 1
                          ? const Color(0xFF0F4C81).withOpacity(0.1)
                          : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 1 ? Icons.event : Icons.event_outlined,
                  size: 24,
                ),
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == 2
                          ? const Color(0xFF0F4C81).withOpacity(0.1)
                          : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 2 ? Icons.chat : Icons.chat_outlined,
                  size: 24,
                ),
              ),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == 3
                          ? const Color(0xFF0F4C81).withOpacity(0.1)
                          : Colors.transparent,
                ),
                child: Icon(
                  _currentIndex == 3 ? Icons.person : Icons.person_outlined,
                  size: 24,
                ),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
