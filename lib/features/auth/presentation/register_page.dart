import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final pass2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final passwordHintsText =
        passwordIssues('').map((issue) => '• $issue').join('\n');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // HERO superior
          Image.asset(
            'assets/ui/main_bg.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: Colors.black),
          ),
          // Gradiente sutil para contraste
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.30),
                  ],
                ),
              ),
            ),
          ),

          // Flecha de retorno
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
                      context.go('/'); // fallback a MainPage
                    }
                  },
                ),
              ),
            ),
          ),

          // BLOQUE INFERIOR anclado
          SafeArea(
            bottom: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + viewInsets),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 18,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: Text(
                              'Registrar usuario',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFD28AD9), // morado del título
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
                          const SizedBox(height: 14),

                          const Text('Contraseña'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: pass,
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
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              passwordHintsText,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          const Text('Repetir Contraseña'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: pass2,
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
                          const SizedBox(height: 18),

                          // Botón Registrar (negro con sombra)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  elevation: 0, // sombra del DecoratedBox
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  shadowColor: Colors.black, // <- color de la sombra
                                  surfaceTintColor: Colors.transparent,
                                ),
                                onPressed: () {
                                  final emailValue = email.text.trim();
                                  final passwordValue = pass.text.trim();
                                  final confirmPasswordValue = pass2.text.trim();

                                  email.text = emailValue;
                                  pass.text = passwordValue;
                                  pass2.text = confirmPasswordValue;

                                  if (emailValue.isEmpty ||
                                      passwordValue.isEmpty ||
                                      confirmPasswordValue.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Completa todos los campos antes de continuar.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (!isValidEmail(emailValue)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Ingresa un correo electrónico válido.'),
                                      ),
                                    );
                                    return;
                                  }

                                  final issues = passwordIssues(passwordValue);
                                  if (issues.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          issues.map((issue) => '• $issue').join('\n'),
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (passwordValue != confirmPasswordValue) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Las contraseñas no coinciden.'),
                                      ),
                                    );
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Formulario válido. Continua con el registro.'),
                                    ),
                                  );
                                  // TODO: registrar
                                },
                                child: const Text('Registrar'),
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
        ],
      ),
    );
  }
}
