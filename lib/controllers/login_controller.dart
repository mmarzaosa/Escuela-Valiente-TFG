import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  // Función principal de login que devuelve un String si hay error o null si va bien
  Future<String?> performLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return "¡No olvides rellenar todos los campos!";
    }

    try {
      await _authService.signIn(username, password);
      return null; // Todo correcto
    } catch (e) {
      return e.toString(); // Devolvemos el mensaje de error del servicio
    }
  }
}