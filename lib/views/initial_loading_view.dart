import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_texts.dart';
import '../theme/app_colors.dart';
import 'home_view.dart';
import 'login_view.dart';

class InitialLoadingView extends StatefulWidget {
  const InitialLoadingView({super.key});

  @override
  State<InitialLoadingView> createState() => _InitialLoadingViewState();
}

class _InitialLoadingViewState extends State<InitialLoadingView>
    with TickerProviderStateMixin {
  // Controladores de animación
  late AnimationController _progressController;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _floatingAnimation = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _progressController.forward();
    _floatingController.repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Esperamos a que la barra visual termine su recorrido
    await Future.delayed(const Duration(milliseconds: 2700));

    try {
      // --- PASO 1: Comprobar Internet ---
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // --- PASO 2: Si hay internet, mirar sesión de Firebase ---
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          _navigateTo(const HomeView(isGuest: false));
        } else {
          _navigateTo(const LoginView());
        }
      }
    } on SocketException catch (_) {
      // --- PASO 3: Si NO hay internet, ir al Login con el aviso ---
      _navigateTo(const LoginView(showOfflinePopup: true));
    } catch (e) {
      // Error genérico: Mandamos al login por seguridad
      _navigateTo(const LoginView());
    }
  }

  void _navigateTo(Widget targetView) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetView),
      );
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loading_background.png"), 
              fit: BoxFit.cover,
            ),
          ),
        ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // LUMI FLOTANDO
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_floatingAnimation.value),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    "assets/images/star_learn.png",
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                // TEXTO Y BARRA DE CARGA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Column(
                    children: [
                      Text(
                        AppTexts.getText('loading_adventure').toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Contenedor de la Barra
                      Container(
                        height: 16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.darkBlue,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedBuilder(
                            animation: _progressController,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressController.value,
                                backgroundColor: Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.orangeMain,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
