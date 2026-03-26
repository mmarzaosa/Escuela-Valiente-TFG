import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF1A4D8F);
    const Color orangeMain = Color(0xFFFF9430);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 15),

                Text(
                  "MIS LOGROS",
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight:
                        FontWeight.w400, // Más grosor para toque infantil
                    color: const Color(0xFF1A4D8F),
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.5),
                        offset: const Offset(3, 3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),

                // 1. EL FONDO (Borde naranja grueso)
                const SizedBox(height: 5),

                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 178, 62),
                      width: 6,
                    ),
                  ),

                  child: ClipOval(
                    child: Transform.translate(
                      offset: const Offset(
                        0,
                        14,
                      ), // El primer número es X (izq/der), el segundo es Y (arriba/abajo)
                      child: Transform.scale(
                        scale: 1.8,
                        child: Image.asset(
                          "assets/icon/icon_profile_boy.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // NOMBRE
                Row(
                  mainAxisSize:
                      MainAxisSize.min, // Centra el conjunto en la pantalla
                  children: [
                    const Text(
                      "Marc",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight:
                            FontWeight.w400, // Más grosor para toque infantil
                        color: Color(0xFF1A4D8F),
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.white,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Icono de rayo con degradado naranja
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFF9430), Color(0xFFFF6100)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        color: Colors
                            .white, // Color base para que aplique el ShaderMask
                        size: 34,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // PACK DE PROGRESO
                _buildPackContainer(
                  child: _buildProgressContent(orangeMain, darkBlue),
                ),

                const SizedBox(height: 20),

                // PACK DE AJUSTES
                _buildPackContainer(
                  child: _buildMenuContent(darkBlue, orangeMain),
                ),

                // Espacio para la barra de navegación
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS DE APOYO ---

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/profile_background.png",
          ), // Usamos tu path de fondo
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPackContainer({required Widget child}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
      ),
      child: child,
    );
  }

  Widget _buildProgressContent(Color orangeMain, Color darkBlue) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, color: Color(0xFFD48A14), size: 30),
            const SizedBox(width: 8),
            Text(
              "Nivel 3",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Stack(
          children: [
            Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 14,
                  width: constraints.maxWidth * 0.7,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9430), Color(0xFFFFD93B)],
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuContent(Color darkBlue, Color orangeMain) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(Icons.person_rounded, "Perfil", darkBlue, orangeMain),
        _buildMenuItem(
          Icons.bar_chart_rounded,
          "Progreso",
          darkBlue,
          orangeMain,
        ),
        _buildMenuItem(
          Icons.notifications_active_rounded,
          "Avisos",
          darkBlue,
          orangeMain,
        ),
        _buildMenuItem(
          Icons.help_center_rounded,
          "Ayuda",
          darkBlue,
          orangeMain,
        ),
        const Divider(color: Colors.white24, indent: 20, endIndent: 20),
        _buildMenuItem(
          Icons.logout_rounded,
          "Salir",
          const Color(0xFFC70101),
          const Color(0xFFC70101),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color textColor,
    Color iconColor,
  ) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor.withOpacity(0.3),
      ),
      onTap: () => print("Navegando a $label"),
    );
  }
}
