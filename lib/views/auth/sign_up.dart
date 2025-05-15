import 'dart:async';
import 'dart:io';
import 'package:alumni_busfa/maps/map_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '/services/auth_service.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final jobController = TextEditingController();
  final graduationYearController = TextEditingController();

  bool isLoading = false;
  String? message;

  LatLng? selectedLocation;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_selectedImage == null) return null;
    final fileName = basename(_selectedImage!.path);
    final ref = FirebaseStorage.instance.ref().child(
      'profile_images/$fileName',
    );
    await ref.putFile(_selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _selectLocationFromMap() async {
    final location = await Navigator.push<LatLng>(
      this.context,
      MaterialPageRoute(builder: (_) => MapPickerPage()),
    );
    if (location != null) {
      setState(() {
        selectedLocation = location;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && selectedLocation != null) {
      setState(() => isLoading = true);

      final photoUrl = await _uploadImageToStorage();

      final result = await registerAlumni(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        address: addressController.text.trim(),
        phone: phoneController.text.trim(),
        job: jobController.text.trim(),
        graduationYear: graduationYearController.text.trim(),
        latitude: selectedLocation!.latitude,
        longitude: selectedLocation!.longitude,
        photoUrl: photoUrl,
      );

      setState(() => isLoading = false);

      if (result == 'Pendaftaran berhasil. Tunggu verifikasi admin.') {
        emailController.clear();
        passwordController.clear();
        nameController.clear();
        addressController.clear();
        phoneController.clear();
        jobController.clear();
        graduationYearController.clear();
        selectedLocation = null;
        _selectedImage = null;

        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text("Registrasi berhasil, tunggu verifikasi admin"),
          ),
        );

        Navigator.pushReplacement(
          this.context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        setState(() => message = result);
      }
    } else if (selectedLocation == null) {
      setState(() => message = 'Silakan pilih lokasi di peta');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Alumni")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                  child:
                      _selectedImage == null
                          ? const Icon(
                            Icons.add_a_photo,
                            size: 30,
                            color: Colors.white,
                          )
                          : null,
                  backgroundColor: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),

              makeInput("Nama", nameController),
              makeInput("Email", emailController),
              makeInput("Password", passwordController, obscureText: true),
              makeInput("No HP", phoneController),
              makeInput("Alamat", addressController),

              ElevatedButton.icon(
                onPressed: _selectLocationFromMap,
                icon: const Icon(Icons.map),
                label: Text(
                  selectedLocation == null
                      ? 'Pilih Lokasi di Peta'
                      : 'Ubah Lokasi',
                ),
              ),
              if (selectedLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Lokasi dipilih: (${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)})',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),

              const SizedBox(height: 10),
              makeInput("Pekerjaan", jobController),
              makeInput("Tahun Lulus", graduationYearController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : _register,
                child: Text(isLoading ? "Tunggu..." : "Daftar"),
              ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    message!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator:
            (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
