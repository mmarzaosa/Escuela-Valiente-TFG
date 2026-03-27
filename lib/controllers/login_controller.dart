import '../services/auth_service.dart';

class LoginController {
  final AuthService _authService = AuthService();

  Future<String?> performLogin(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return "¡No olvides rellenar todos los campos!";
    }

    try {
      await _authService.signIn(username, password);
      return null; 
    } catch (e) {
      return e.toString(); 
    }
  }
}