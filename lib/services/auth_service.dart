import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String username, String password) async {
    try {
      final String fakeEmail = "${username.toLowerCase().trim()}@escuelavaliente.com";
      
      print("DEBUG: Intentando login con email '$fakeEmail' y contraseña '$password'");

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );
      print("DEBUG: Login exitoso para '$fakeEmail'");
      return result.user;
    } on FirebaseAuthException catch (e) {
      print ("DEBUG: Error de FirebaseAuth - Código: ${e.code}, Mensaje: ${e.message}");
      throw _mapFirebaseError(e.code);
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return "Ese nombre de usuario no existe";
      case 'wrong-password':
        return "La contraseña es incorrecta";
      case 'invalid-email':
        return "El nombre de usuario tiene caracteres no permitidos";
      case 'network-request-failed':
        return "No hay conexión a internet";
      default:
        return "Algo ha salido mal. ¡Inténtalo de nuevo!";
    }
  }
}