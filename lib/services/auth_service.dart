import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> registerAlumni({
  required String email,
  required String password,
  required String name,
  required String address,
  required String phone,
  required String job,
  required String graduationYear,
  String? profilePictureUrl, // Tambahkan parameter ini
}) async {
  try {
    // Buat akun pengguna di Firebase Authentication
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = credential.user!.uid;

    // Simpan data pengguna di Firestore
    await FirebaseFirestore.instance.collection('pendingAlumni').doc(uid).set({
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'job': job,
      'graduationYear': graduationYear,
      'profilePictureUrl': profilePictureUrl, // Simpan URL gambar
      'isVerified': false, // Status verifikasi
    });

    // Logout pengguna setelah registrasi
    await FirebaseAuth.instance.signOut();

    return 'Pendaftaran berhasil. Tunggu verifikasi admin.';
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'Terjadi kesalahan.';
  }
}

Future<String?> loginAlumni(String email, String password) async {
  try {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    String uid = credential.user!.uid;

    // Cek apakah user sudah diverifikasi di koleksi alumni
    final doc =
        await FirebaseFirestore.instance
            .collection('alumniVerified')
            .doc(uid)
            .get();

    if (!doc.exists || doc.data()?['isVerified'] != true) {
      await FirebaseAuth.instance.signOut();
      return 'Akun belum diverifikasi oleh admin.';
    }

    return null; // login berhasil
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'Login gagal.';
  }
}
