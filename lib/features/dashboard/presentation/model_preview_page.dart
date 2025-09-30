import 'package:flutter/material.dart';

class ModelPreviewPage extends StatelessWidget {
  const ModelPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F3FF),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Muestra del modelo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _buildStepsCard(context),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Ver tu diseño en tiempo real',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          _PreviewGallery(
            imageUrls: const [
              'https://images.unsplash.com/photo-1519014816548-bf5fe059798b?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1582738411864-5cb11ec90a98?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1586253634169-9d3e40ad51fc?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1559599238-203ba76682a1?auto=format&fit=crop&w=600&q=80',
              'https://images.unsplash.com/photo-1572569593498-17a9c0b320bd?auto=format&fit=crop&w=600&q=80',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context) {
    final steps = const [
      'Permite el acceso a la cámara.',
      'Elige un modelo.',
      'Pon tu mano frente a la cámara.',
      'Sigue las guías para ajustar la posición.',
      '¡Listo! Mira cómo te queda.',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final number = index + 1;
          final step = steps[index];
          return Padding(
            padding: EdgeInsets.only(bottom: index == steps.length - 1 ? 0 : 8),
            child: Text(
              '$number. $step',
              style: const TextStyle(height: 1.4, fontSize: 15),
            ),
          );
        }),
      ),
    );
  }
}

class _PreviewGallery extends StatefulWidget {
  const _PreviewGallery({required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<_PreviewGallery> createState() => _PreviewGalleryState();
}

class _PreviewGalleryState extends State<_PreviewGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedImage = widget.imageUrls[_selectedIndex];

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(
              selectedImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final imageUrl = widget.imageUrls[index];
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
