import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(
            'assets/ui/main_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.white),
          ),

          // Gradiente para contraste
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.35),
                ],
              ),
            ),
          ),

          // Contenido CENTRADO
          // Usamos SafeArea sin top para centrar en toda la pantalla,
          // pero respetamos el bottom (gestures / notch).
          SafeArea(
            top: false,
            bottom: true,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // bloque compacto centrado
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo centrado
                      Image.asset(
                        'assets/ui/logo.png',
                        height: 160,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 160),
                      ),
                      const SizedBox(height: 24),

                      // Botón Iniciar sesión (negro)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context.push('/login'),
                          child: const Text('Iniciar sesión'),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Botón Registrar (negro)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => context.push('/register'),
                          child: const Text('Registrar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
