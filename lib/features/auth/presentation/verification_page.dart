// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}


class _VerificationPageState extends State<VerificationPage> {
  final controllers = List.generate(4, (_) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Código de verificación')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset('assets/ui/verify_bg.jpg', height: 160, fit: BoxFit.cover),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: controllers
                .map((c) => SizedBox(
              width: 56,
              child: TextField(
                controller: c,
                textAlign: TextAlign.center,
                maxLength: 1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(counterText: ''),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => context.go('/success'),
              child: const Text('Verificar'),
            ),
          )
        ],
      ),
    );
  }
}