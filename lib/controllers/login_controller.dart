import 'package:firebase_auth/firebase_auth.dart'; // Importante añadir esto
import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<String?> performLogin(String username, String password) async {
    
    if (username.isEmpty || password.isEmpty) {
      return "¡No olvides rellenar todos los campos!";
    }

    try {
      // Intentamos el login normal
      await _authService.signIn(username, password);
      return null; 
    } on FirebaseAuthException catch (e) {
      // --- CAPTURA DE ERRORES ESPECÍFICOS DE FIREBASE ---
      
      if (e.code == 'network-request-failed' || e.code == 'unavailable') {
        return "offline"; // Este String activa el modo invitado en tu View
      }
      
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return "El usuario o la contraseña no son correctos.";
      }

      return "¡Ups! Algo ha fallado: ${e.message}";
      
    } catch (e) {
      // Errores genéricos (fallos de código, etc.)
      return "Ocurrió un error inesperado. Inténtalo de nuevo.";
    }
    
  }
}