import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> registerAlumni({
  required String email,
  required String password,
  required String name,
  required String address,
  required String phone,
  required String job,
  required String graduationYear,
  required double latitude,
  required double longitude,
  String? photoUrl,
}) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance.collection('pendingAlumni').add({
      'uid': credential.user!.uid,
      'email': email,
      'name': name,
      'address': address,
      'phone': phone,
      'job': job,
      'graduationYear': graduationYear,
      'latitude': latitude,
      'longitude': longitude,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.now(),
      'verified': false,
    });

    return 'Pendaftaran berhasil. Tunggu verifikasi admin.';
  } on FirebaseAuthException catch (e) {
    return e.message ?? 'Terjadi kesalahan';
  } catch (e) {
    return 'Gagal mendaftar: $e';
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
