import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(
            'assets/ui/main_bg.jpg', // cámbialo a .png si corresponde
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
          // Gradiente para contraste
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.40),
                ],
              ),
            ),
          ),

          // Flecha de retorno (sobre el fondo)
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.35),
                  ),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    } else {
                      context.go('/'); // fallback a la principal
                    }
                  },
                ),
              ),
            ),
          ),

          // BLOQUE INFERIOR (anclado abajo)
          SafeArea(
            bottom: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + viewInsets),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Material(
                      color: const Color(0xFFE8E8E8),
                      elevation: 8,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Center(
                              child: Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD28AD9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            const Text('Email'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            const Text('Contraseña'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: password,
                              obscureText: true,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Botón negro
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 8, // <- sombra
                                  shadowColor: Colors.black, // <- color de la sombra
                                  surfaceTintColor: Colors.transparent, // M3: evita tinte que aclare el botón
                                ),
                                onPressed: () {
                                  // TODO: login
                                },
                                child: const Text('Iniciar sesión'),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Recuperar + Registrarse
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => context.push('/new-password'),
                                  child: const Text('Recuperar contraseña'),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 36,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEAA882),
                                      foregroundColor: Colors.black87,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      elevation: 8, // <- sombra
                                      shadowColor: Colors.black, // <- color de la sombra
                                      surfaceTintColor: Colors.transparent, // M3: evita tinte que aclare el botón
                                    ),
                                    onPressed: () => context.push('/register'),
                                    child: const Text('Regístrate'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 8),

                            const Center(child: Text('Puedes iniciar sesión con:')),
                            const SizedBox(height: 8),

                            SizedBox(
                              height: 44,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Google sign-in
                                },
                                icon: const Icon(Icons.g_mobiledata_rounded),
                                label: const Text('Iniciar sesión con Google'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(width: 1),
                                  elevation: 8, // <- sombra
                                  shadowColor: Colors.black, // <- color de la sombra
                                  surfaceTintColor: Colors.transparent, // M3: evita tinte que aclare el botón
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            SizedBox(
                              height: 44,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // TODO: Facebook sign-in
                                },
                                icon: const Icon(Icons.facebook),
                                label: const Text('Iniciar sesión con Facebook'),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(width: 1),
                                  elevation: 8, // <- sombra
                                  shadowColor: Colors.black, // <- color de la sombra
                                  surfaceTintColor: Colors.transparent, // M3: evita tinte que aclare el botón
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
