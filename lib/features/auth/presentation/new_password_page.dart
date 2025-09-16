// TODO Implement this library.
import 'package:flutter/material.dart';
import '_shared.dart';


class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});
  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}


class _NewPasswordPageState extends State<NewPasswordPage> {
  final p1 = TextEditingController();
  final p2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset('assets/ui/newpwd_bg.jpg', height: 160, fit: BoxFit.cover),
          const SizedBox(height: 16),
          AuthTextField(hint: 'Nueva contraseña', controller: p1, obscure: true),
          const SizedBox(height: 12),
          AuthTextField(hint: 'Repetir contraseña', controller: p2, obscure: true),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Cambiar contraseña', onPressed: () {}),
        ],
      ),
    );
  }
}