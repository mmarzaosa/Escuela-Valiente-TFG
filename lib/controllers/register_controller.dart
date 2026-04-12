import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_texts.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> performRegister({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 10));

      // 2. Crear el perfil en Cloud Firestore
      // Usamos .timeout para evitar que la app se quede colgada si las reglas fallan
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'gender': gender,
        'createdAt': FieldValue.serverTimestamp(),
        'levels': {
          'level_1': 'unlocked',
          'level_2': 'locked',
          'level_3': 'locked',
          'level_4': 'locked',
        },
      }).timeout(const Duration(seconds: 10));

      return null; // Éxito total
    } on FirebaseAuthException catch (e) {
      // Errores específicos de Auth
      if (e.code == 'email-already-in-use') return AppTexts.getText('error_email_exists');
      if (e.code == 'weak-password') return AppTexts.getText('error_weak_pass');
      if (e.code == 'network-request-failed') return "Revisa tu conexión a internet";
      return e.message;
    } catch (e) {
      // Captura errores de Firestore o de tiempo de espera
      if (e.toString().contains('timeout')) {
        return "La base de datos no responde. Revisa las reglas de Firestore.";
      }
      return "Error inesperado: ${e.toString()}";
    }
  }
}