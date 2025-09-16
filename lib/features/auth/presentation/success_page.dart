// TODO Implement this library.
import 'package:flutter/material.dart';


class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/ui/success_bg.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.25)),
          const Center(
            child: Card(
              margin: EdgeInsets.all(24),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 56),
                    SizedBox(height: 12),
                    Text('¡Verificado/a!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    SizedBox(height: 6),
                    Text('Tu cuenta ha sido exitosamente verificada'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}