import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityDetailPage extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityDetailPage({Key? key, required this.activity})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final timeFormat = DateFormat('h:mm a');
    final eventDate = activity['date'].toDate();
    final formattedDate = dateFormat.format(eventDate);
    final formattedTime = timeFormat.format(eventDate);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background:
                  activity['imageUrl'] != null
                      ? Image.network(
                        activity['imageUrl']!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.event,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                      )
                      : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.event,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              title: Text(
                activity['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareActivity(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Date & Time
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                              ),
                            ),
                            title: const Text(
                              "Date & Time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("$formattedDate\n$formattedTime"),
                          ),
                          const Divider(height: 1),
                          if (activity['location'] != null)
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                ),
                              ),
                              title: const Text(
                                "Location",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(activity['location']),
                              trailing: IconButton(
                                icon: const Icon(Icons.directions),
                                onPressed: () => _openMap(activity['location']),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // About Event
                  const Text(
                    "About Event",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Organizer Info
                  if (activity['organizer'] != null)
                    const Text(
                      "Organized By",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (activity['organizer'] != null) const SizedBox(height: 8),
                  if (activity['organizer'] != null)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: const Icon(Icons.person, color: Colors.orange),
                        ),
                        title: Text(
                          activity['organizer'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            activity['organizerContact'] != null
                                ? Text(activity['organizerContact'])
                                : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.message),
                          onPressed:
                              () => _contactOrganizer(
                                activity['organizerContact'],
                              ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Event Agenda
                  if (activity['agenda'] != null)
                    const Text(
                      "Event Agenda",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (activity['agenda'] != null) const SizedBox(height: 8),
                  if (activity['agenda'] != null)
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            for (var item in (activity['agenda'] as List).take(
                              3,
                            ))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${(activity['agenda'] as List).indexOf(item) + 1}",
                                          style: TextStyle(
                                            color: Colors.blue.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['time'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(item['activity']),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if ((activity['agenda'] as List).length > 3)
                              TextButton(
                                onPressed: () {
                                  // Show full agenda
                                },
                                child: const Text("View Full Agenda"),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Registration Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Register for event
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        "Register for Event",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Add to calendar
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.blue),
                      ),
                      child: const Text(
                        "Add to Calendar",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareActivity() {
    // Implement share functionality
  }

  void _openMap(String location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$location';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _contactOrganizer(String? contact) {
    if (contact == null) return;
    // Implement contact functionality
  }
}
