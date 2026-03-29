import '../services/auth_service.dart';

class ProfileController {
  final AuthService _authService = AuthService();

  Future<void> handleLogout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }
}