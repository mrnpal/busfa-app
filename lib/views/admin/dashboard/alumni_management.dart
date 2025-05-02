import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AlumniManagement extends StatefulWidget {
  const AlumniManagement({super.key});

  @override
  State<AlumniManagement> createState() => _AlumniManagementState();
}

class _AlumniManagementState extends State<AlumniManagement> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference alumni = firestore.collection('alumni');

    return Scaffold(
      appBar: AppBar(title: Text('Dashboard Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Alumni',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty) {
                  alumni.add({
                    'name': nameController.text,
                    'address': addressController.text,
                  });
                  nameController.clear();
                  addressController.clear();
                }
              },
              child: Text('Tambah Alumni'),
            ),
            SizedBox(height: 24),
            Text(
              'Data Alumni',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: alumni.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Belum ada data alumni.'));
                  }
                  final data = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final alumniData = data[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(alumniData['name']),
                          subtitle: Text(alumniData['address']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Isi TextField dengan data yang akan diedit
                                  nameController.text = alumniData['name'];
                                  addressController.text =
                                      alumniData['address'];

                                  // Tampilkan dialog untuk mengedit data
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Edit Alumni'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText: 'Name',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            TextField(
                                              controller: addressController,
                                              decoration: InputDecoration(
                                                labelText: 'Address',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Update data di Firestore
                                              alumni.doc(alumniData.id).update({
                                                'name': nameController.text,
                                                'address':
                                                    addressController.text,
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  alumni.doc(alumniData.id).delete();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
