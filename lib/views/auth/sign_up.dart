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
  bool _obscurePassword = true;
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
      MaterialPageRoute(
        builder: (_) => MapPickerPage(),
        fullscreenDialog: true,
      ),
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
          SnackBar(
            content: const Text("Registrasi berhasil, tunggu verifikasi admin"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Alumni"),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child:
                            _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Informasi Pribadi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Name Field
              _buildTextField(
                controller: nameController,
                label: 'Nama Lengkap',
                icon: Icons.person_outline,
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              // Email Field
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(val)) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password Field
              _buildTextField(
                controller: passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                  if (val.length < 6) return 'Minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Phone Field
              _buildTextField(
                controller: phoneController,
                label: 'Nomor HP',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                  if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                    return 'Hanya angka yang diperbolehkan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Field
              _buildTextField(
                controller: addressController,
                label: 'Alamat',
                icon: Icons.home_outlined,
                maxLines: 2,
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              // Location Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: _selectLocationFromMap,
                    icon: const Icon(Icons.map_outlined),
                    label: Text(
                      selectedLocation == null
                          ? 'Pilih Lokasi di Peta'
                          : 'Ubah Lokasi',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  if (selectedLocation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Lokasi dipilih: (${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)})',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Informasi Alumni',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Job Field
              _buildTextField(
                controller: jobController,
                label: 'Pekerjaan',
                icon: Icons.work_outline,
                validator:
                    (val) =>
                        val == null || val.trim().isEmpty
                            ? 'Wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              // Graduation Year Field
              _buildTextField(
                controller: graduationYearController,
                label: 'Tahun Lulus',
                icon: Icons.school_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Wajib diisi';
                  if (!RegExp(r'^\d{4}$').hasMatch(val)) {
                    return 'Format tahun tidak valid (contoh: 2023)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Register Button
              ElevatedButton(
                onPressed: isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child:
                    isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Daftar Sekarang',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
              const SizedBox(height: 16),

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sudah punya akun?',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text('Masuk disini'),
                  ),
                ],
              ),

              // Error Message
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
    );
  }
}
